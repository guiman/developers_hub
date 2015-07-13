module RecruiterExtensions
  class GithubSearchIndexUpdater
    def perform_one(candidate, client)
      if existing_indexed_candidate = Developer.find_by_login(candidate.login)
        existing_indexed_candidate.update(name: candidate.name,
                                          hireable: candidate.hireable,
                                          location: candidate.location,
                                          gravatar_url: candidate.avatar_url,
                                          geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
                                          email: candidate.email)

        user = existing_indexed_candidate
      else
        user = Developer.create(name: candidate.name,
                         hireable: candidate.hireable,
                         login: candidate.login,
                         location: candidate.location,
                         gravatar_url: candidate.avatar_url,
                         geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
                         email: candidate.email)
      end

      candidate.languages.each do |language, repos|
        repos = repos.map(&:symbolize_keys)
        skill = Skill.find_or_create_by(name: language.to_s)
        sorted_repos = repos.sort { |a,b| b[:popularity] <=> a[:popularity] }
        top_skill_repo = sorted_repos.detect { |repo| repo.fetch(:main_language).to_s == language.to_s }

        # Only take in consideration relevant skills
        if !top_skill_repo.nil? && (repos.count >= 2 || top_skill_repo.fetch(:popularity) >= 3)
          dev_skill = DeveloperSkill.find_or_initialize_by(skill_id: skill.id, developer_id: user.id)
          dev_skill.code_example = top_skill_repo.fetch(:name)
          dev_skill.strength = repos.count
          dev_skill.save
        end
      end

      user
    end
  end
end
