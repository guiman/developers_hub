require 'octokit'

module RecruiterExtensions
  class BuildDeveloperProfile
    def initialize(auth_info)
      @auth_info = auth_info
    end

    def perform
      developer = Developer.find_by_uid(@auth_info.uid)

      if developer.nil?
        developer = Developer.create_from_auth_hash(@auth_info)
      else
        developer.update_from_auth_hash(@auth_info)
      end

      client = Octokit::Client.new(access_token: developer.token)
      github_data = client.user(developer.login)
      github_candidate = Recruiter::GithubCandidate.new(github_data)

      GithubSearchIndexUpdater.new.perform_one(github_candidate, client)
    end
  end
end
