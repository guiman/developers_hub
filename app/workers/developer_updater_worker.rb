class DeveloperUpdaterWorker
  include Sidekiq::Worker
  def perform(login, parse_activity=false)
    RecruiterExtensions::UpdateDeveloperFromGithub.perform(login, parse_activity)
  end
end
