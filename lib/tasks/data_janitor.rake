namespace :data_janitor do
  desc "Unify developers"
  task unify_developers: :environment do
    duplicated_developers = Developer.select("login, count(id) as login_count").group("login").having("login_count > 1")
    duplicated_developers.each do |dev|
      developers = Developer.where(login: dev.login)
      real_developer = developers.first
      copied_developer = developers.last
      real_developer.email ||= copied_developer.email
      real_developer.location ||= copied_developer.location
      real_developer.geolocation ||= copied_developer
      real_developer.hireable ||= copied_developer.hireable
      real_developer.languages ||= copied_developer.languages
      real_developer.gravatar_url ||= copied_developer.gravatar_url
      real_developer.uid ||= copied_developer.uid
      real_developer.token ||= copied_developer.token

      real_developer.save
      copied_developer.delete
    end
  end

  desc "Fix geolocations"
  task fix_missing_geolocations: :environment do
    Geokit::Geocoders::MapboxGeocoder.key = 'pk.eyJ1IjoiYWx2YXJvbGEiLCJhIjoicjkxUGpONCJ9.lYnv1rHrMRVzy5r5PM5ivg'
    users_with_faulty_geolocation = Developer.where(geolocation: ",")
    users_with_faulty_geolocation.each do |user|
      user.update(geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(user.location.gsub(/\;/, ' ')).ll)
    end
  end

  desc "update code_examples from github"
  task :update_users_skills => :environment do |t, args|
    require 'logger'
    require 'recruiter'
    require 'recruiter/cached_search_strategy'

    logger = Logger.new(Rails.root.join('log', 'migrator.log'))
    logger.level = Logger::DEBUG

    developers = Developer.joins(:developer_skills).where(hireable: true).distinct

    logger.info("Processing #{developers.count} developers to update code examples")

    developers.each do |developer|
      Proc.new do
        begin
          github_user = ::Recruiter::API.build_client.user(developer.login)
          candidate = Recruiter::GithubCandidate.new(github_user)

          candidate.languages.each do |language, repos|
            skill = Skill.find_or_create_by(name: language.to_s)
            top_skill_repo = repos.sort{ |a,b| b[:popularity] <=> a[:popularity] }.first.fetch(:name)
            dev_skill = DeveloperSkill.find_or_initialize_by(skill_id: skill.id, developer_id: developer.id)
            dev_skill.code_example = top_skill_repo
            dev_skill.strength = repos.count
            dev_skill.save
          end

          logger.info("#{developer.login} updated!")
        rescue Octokit::NotFound
          logger.fatal("#{developer.login} cannot be updated!")
        end
      end.call
    end
  end


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

end
