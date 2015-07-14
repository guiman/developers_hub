require 'recruiter'
require 'recruiter/cached_github_candidate'
require 'recruiter/cached_github_organization'

class CompareAgainstOrg
  def self.perform(comparator, client, redis_client, user, org, language_whitelist=[])
    caching_method = Recruiter::RedisCache.new(redis_client)
    candidate = Recruiter::GithubCandidate.new(client.user(user), client)
    cached_candidate = Recruiter::CachedGithubCandidate.new(candidate, caching_method)

    org = Recruiter::GithubOrganization.new(client.user(org), client)
    cached_org = Recruiter::CachedGithubOrganization.new(org, caching_method)

    members = if cached_org.login == "Alliants"
      cached_org.members('all')
    else
      cached_org.members('public')
    end

    comparator.compare_against_collection(cached_candidate, members, cached_org,
      language_whitelist)
  end
end
