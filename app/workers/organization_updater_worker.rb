class OrganizationUpdaterWorker
  include Sidekiq::Worker
  def perform(login, options={parse_activity: false })
    RecruiterExtensions::UpdateOrganizationFromGithub.perform(login, options.symbolize_keys)
  end
end
