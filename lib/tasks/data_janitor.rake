namespace :data_janitor do
  desc "migrate users from github"
  task :migrate_from_github, [:search_term] => :environment do |t, args|
    require 'logger'
    require 'recruiter'
    require 'recruiter/cached_search_strategy'

    logger = Logger.new(Rails.root.join('log', 'migrator.log'))
    logger.level = Logger::DEBUG

    search_term = args[:search_term].to_s

    logger.info("Now processing #{search_term}")
    search = Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy)
    .at(search_term)

    candidates = search.all

    logger.info("#{search_term} users count: #{candidates.count}")
    RecruiterExtensions::GithubSearchIndexUpdater.new(candidates).perform
  end

  desc "migrate users from crawler"
  task :migrate_from_crawler => :environment do |t, args|
    require 'logger'
    require 'ostruct'

    logger = Logger.new(Rails.root.join('log', 'crawler_migrator.log'))
    logger.level = Logger::DEBUG

    Dir["#{Rails.root}/crawler/**/*.json"].each do |file_path|
      logger.info("Now processing #{file_path}")
      File.open(file_path) do |file|
        data = JSON.parse(file.read)
        logger.info("Users count: #{data.count}")
        candidates = data.map { |d| OpenStruct.new(d) }
        candidates.each do |candidate|
          RecruiterExtensions::GithubSearchIndexUpdater.new.perform_one(candidate)
        end
      end
    end
  end

  desc "update users from crawler"
  task :update_from_crawler => :environment do |t, args|
    require 'logger'
    require 'ostruct'

    logger = Logger.new(Rails.root.join('log', 'user_updater.log'))
    logger.level = Logger::DEBUG

    FileUtils.mkdir_p "/tmp/updated_users/to_be_updated"
    FileUtils.mkdir_p "/tmp/updated_users/already_updated"

    Dir["/tmp/updated_users/to_be_updated/*.json"].each do |file_path|
      logger.info("Now processing #{file_path}")

      File.open(file_path) do |file|
        data = JSON.parse(file.read)
        candidate = OpenStruct.new(data)
        logger.info("User #{candidate.name}")
        RecruiterExtensions::GithubSearchIndexUpdater.new.perform_one(candidate)
      end

      FileUtils.mv(file_path, "/tmp/updated_users/already_updated/")
    end
  end
end
