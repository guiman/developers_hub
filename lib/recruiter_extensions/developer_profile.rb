module RecruiterExtensions
  class DeveloperProfile
    def self.create(github_login:)
      return unless github_login

      if existing_developer = Developer.find_by_login(github_login)
        return existing_developer
      end

      developer = Developer.create(login: github_login)

      DeveloperUpdaterWorker.perform_async(developer.login, { parse_contributions: true })

      begin
        DeveloperUpdaterWorker.new.perform(developer.login, { parse_contributions: false })
      rescue Exception
      end

      developer
    end
  end
end
