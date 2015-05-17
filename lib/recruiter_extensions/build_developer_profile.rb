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
        DeveloperUpdaterWorker.new.perform(developer.login, {
          parse_activity: false, parse_contributions: false })
        DeveloperUpdaterWorker.perform_async(developer.login, {
          parse_activity: true, parse_contributions: true })
      else
        developer.update_from_auth_hash(@auth_info)
        DeveloperUpdaterWorker.perform_async(developer.login,{
          parse_activity: developer.needs_update_activity?,
          parse_contributions: developer.needs_update_contributions? })
      end

      developer
    end
  end
end
