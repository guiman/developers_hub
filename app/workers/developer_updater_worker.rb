class DeveloperUpdaterWorker
  include Sidekiq::Worker
  def perform(login, options={parse_activity: false, parse_contributions: false})
    RecruiterExtensions::UpdateDeveloperFromGithub.perform(login, options.symbolize_keys)
  end
end
