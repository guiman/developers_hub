module RecruiterExtensions
  class GithubSearchIndexUpdater
    def initialize(candidates)
      @candidates = candidates
    end

    def perform
      @candidates.each do |candidate|
        if existing_indexed_candidate = Developer.find_by_github_login(candidate.github_login)
          existing_indexed_candidate.update(name: candidate.name,
            hireable: candidate.hireable,
            location: candidate.location,
            geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
            email: candidate.email,
            languages: candidate.languages)

        else
          Developer.create(name: candidate.name,
            hireable: candidate.hireable,
            github_login: candidate.github_login,
            location: candidate.location,
            geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(candidate.location).ll,
            email: candidate.email,
            languages: candidate.languages)
        end
      end
    end
  end
end
