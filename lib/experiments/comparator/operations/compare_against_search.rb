require 'recruiter'
require 'recruiter/cached_github_candidate'
require 'recruiter/cached_search_strategy'

class CompareAgainstSearch
  def self.perform(comparator, client, redis_client, user, location: nil, skills: nil, hireable: nil)
    caching_method = Recruiter::RedisCache.new(redis_client)
    candidate = Recruiter::GithubCandidate.new(client.user(user), client)
    cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)

    search = Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy, client: client, redis_client: redis_client)
    search.at(location) if location
    search.skills(skills) if skills
    collection = search.all
    collection = collection.select { |usr| usr.hireable } if hireable

    comparator.compare_against_collection(cached_candidate, collection)
  end
end
