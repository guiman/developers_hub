module RecruiterExtensions
  class GithubSearchIndexUpdater
    def initialize(candidates)
      @candidates = candidates
    end

    def perform
      @candidates.each do |candidate|
        if existing_indexed_candidate = RecruiterExtensions::IndexedUser.find_by_login(candidate.login)
          existing_indexed_candidate.update(name: candidate.name,
            hireable: candidate.hireable,
            location: candidate.location,
            geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
            email: candidate.email,
            languages: candidate.languages)

        else
          RecruiterExtensions::IndexedUser.create(name: candidate.name,
            hireable: candidate.hireable,
            login: candidate.login,
            location: candidate.location,
            geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
            email: candidate.email,
            languages: candidate.languages)
        end
      end
    end
  end
end
