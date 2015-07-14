require 'recruiter'
require 'recruiter/cached_github_candidate'

class CompareAgainstUser
  def self.perform(comparator, client, redis_client, user, other_user, language_whitelist=[])
    caching_method = Recruiter::RedisCache.new(redis_client)
    candidate = Recruiter::GithubCandidate.new(client.user(user), client)
    cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)

    other_candidate = Recruiter::GithubCandidate.new(client.user(other_user), client)
    cached_other_candidate = Recruiter::CachedGithubCandidate.new(other_candidate, caching_method)

    comparator.compare_two_users(cached_candidate, cached_other_candidate, nil, language_whitelist)
  end
end
