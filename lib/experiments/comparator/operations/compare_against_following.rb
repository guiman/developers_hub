require 'recruiter'
require 'recruiter/cached_github_candidate'

class CompareAgainstFollowing
  def self.perform(comparator, client, redis_client, user)
    caching_method = Recruiter::RedisCache.new(redis_client)
    candidate = Recruiter::GithubCandidate.new(client.user(user), client)
    cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)

    comparator.compare_against_collection(cached_candidate, cached_candidate.following)
  end
end
