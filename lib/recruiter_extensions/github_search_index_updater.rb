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
                                          email: candidate.email,
                                          languages: candidate.languages)
        user = existing_indexed_candidate
      else
        user = Developer.create(name: candidate.name,
                         hireable: candidate.hireable,
                         login: candidate.login,
                         location: candidate.location,
                         gravatar_url: candidate.avatar_url,
                         geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
                         email: candidate.email,
                         languages: candidate.languages)
      end

      user
    end
  end
end
