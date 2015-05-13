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
        DeveloperUpdaterWorker.new.perform(developer.login, false)
      else
        developer.update_from_auth_hash(@auth_info)
      end

      DeveloperUpdaterWorker.perform_async(developer.login, true)

      developer
    end
  end
end
