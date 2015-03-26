require 'octokit'

module RecruiterExtensions
  class BuildDeveloperProfile
    def initialize(auth_info)
      @auth_info = auth_info
    end

    def perform
      developer = Developer.find_by_uid(@auth_info.uid)
      developer = Developer.create_from_auth_hash(@auth_info) if developer.nil?

      github_data = Octokit::Client.new(access_token: developer.token).user(developer.login)
      github_candidate = Recruiter::GithubCandidate.new(github_data)

      GithubSearchIndexUpdater.new.perform_one(github_candidate)
    end
  end
end
