module RecruiterExtensions
  class GithubSearchIndexUpdater
    def initialize(candidates=[])
      @candidates = candidates
    end

    def perform
      @candidates.each { |candidate| perform_one(candidate) }
    end

    def perform_one(candidate)
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

      candidate.languages.each do |language, strength|
        skill = Skill.find_or_create_by(name: language.to_s)
        dev_skill = DeveloperSkill.find_or_initialize_by(skill_id: skill.id, developer_id: user.id)
        dev_skill.strength = strength
        dev_skill.save
      end

      user
    end
  end
end
