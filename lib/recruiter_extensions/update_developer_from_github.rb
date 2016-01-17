module RecruiterExtensions
  class UpdateDeveloperFromGithub
    def self.perform(login, parse_options)
      developer = Developer.find_by_login(login)
      token = developer.token
      token = ENV["GITHUB_ACCESS_TOKEN"] if developer.token.nil?
      client = Octokit::Client.new(access_token: token)
      github_data = client.user(developer.login)
      candidate = Recruiter::GithubCandidate.new(github_data, client)

      developer.update(name: candidate.name,
        hireable: candidate.hireable,
        location: candidate.location,
        gravatar_url: candidate.avatar_url,
        geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
        email: candidate.email)

      DeveloperSkill.create_from_candidate(developer: developer, candidate: candidate)

      if parse_options.fetch(:parse_contributions)
        candidate.contributions.each do |org_contributions|
          contributions_by_language = org_contributions.last.group_by { |contrib| contrib[:main_language] }.
            map { |lang, contrib| [ lang, contrib.count ] }

          contributions_by_language.each do |contrib|
            language = contrib.first
            contribution_count = contrib.last
            skill = Skill.find_or_create_by(name: language.to_s)
            dev_skill = DeveloperSkill.find_or_initialize_by(skill_id: skill.id, developer_id: developer.id)
            current_strength = dev_skill.strength.nil? ? 0 : dev_skill.strength
            dev_skill.strength = current_strength + contribution_count
            dev_skill.save
          end
        end

        developer.needs_update_contributions = false
        developer.save
      end
    end
  end
end
