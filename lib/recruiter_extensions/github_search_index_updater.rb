require 'geolocation_adapter'

module RecruiterExtensions
  class GithubSearchIndexUpdater
    def perform_one(candidate)
      candidate_geolocation = GeolocationAdapter.coordinates_based_on_address(candidate.location)

      if existing_indexed_candidate = Developer.find_by_login(candidate.login)
        existing_indexed_candidate.update(name: candidate.name,
                                          hireable: candidate.hireable,
                                          location: candidate.location,
                                          gravatar_url: candidate.avatar_url,
                                          geolocation: candidate_geolocation,
                                          email: candidate.email)

        user = existing_indexed_candidate
      else
        user = Developer.create(name: candidate.name,
                         hireable: candidate.hireable,
                         login: candidate.login,
                         location: candidate.location,
                         gravatar_url: candidate.avatar_url,
                         geolocation: candidate_geolocation,
                         email: candidate.email)
      end

      DeveloperSkill.create_from_candidate(developer: user, candidate: candidate)

      user
    end
  end
end
