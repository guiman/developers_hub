module RecruiterExtensions
  class GithubSearchIndexUpdater
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

      DeveloperSkill.create_from_candidate(developer: user, candidate: candidate)

      user
    end
  end
end
