module RecruiterExtensions
  class UpdateOrganizationFromGithub
    def self.perform(login, parse_options)
      organization = Organization.find_by_login(login)
      client = Octokit::Client.new(access_token: parse_options.fetch(:token))
      github_data = client.org(organization.login)
      github_org = Recruiter::GithubOrganization.new(github_data, client)

      organization.update(name: github_org.name,
        location: github_org.location,
        gravatar_url: github_org.avatar_url,
        geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(github_org.location).ll,
        email: github_org.email)

      if parse_options.fetch(:parse_activity)
        organization.update_attributes(activity: github_org.activity.parse_activity)
      end

      github_org.languages.each do |language, repos|
        repos = repos.map(&:symbolize_keys)
        skill = Skill.find_or_create_by(name: language.to_s)
        sorted_repos = repos.sort { |a,b| b[:popularity] <=> a[:popularity] }
        top_skill_repo = sorted_repos.detect { |repo| repo.fetch(:main_language).to_s == language.to_s }

        # Only take in consideration relevant skills
        if !top_skill_repo.nil?
          dev_skill = OrganizationSkill.find_or_initialize_by(skill_id: skill.id, organization_id: organization.id)
          dev_skill.strength = repos.count
          dev_skill.save
        end
      end
    end
  end
end
