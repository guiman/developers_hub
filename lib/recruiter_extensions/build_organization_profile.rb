require 'octokit'

module RecruiterExtensions
  class BuildOrganizationProfile
    def initialize(login, token)
      @login = login
      @token = token
    end

    def perform
      organization = Organization.find_by_login(@login)

      if organization.nil?
        organization = Organization.create(login: @login)
        OrganizationUpdaterWorker.new.perform(organization.login, { parse_activity: false, token: @token })
      end

      OrganizationUpdaterWorker.perform_async(organization.login, { parse_activity: true, token: @token })

      organization
    end
  end
end
