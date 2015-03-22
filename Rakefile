require_relative 'initialize'
require_relative 'lib/migration_loader'

task :migrate_up do
  migrations = MigrationLoader.migrations(File.join(__dir__, 'migrations', '*.rb'))
  migrations = migrations.select { |pair| pair.first == "201503220918"  }
  migrations.map { |pair| pair.last }.each(&:up)
end

task :migrate_down do
  migrations = MigrationLoader.migrations(File.join(__dir__, 'migrations', '*.rb'))
  migrations = migrations.select { |pair| pair.first == "201503220918"  }
  migrations.map { |pair| pair.last }.each(&:down)
end

task :add_gravatars do
  RecruiterExtensions::IndexedUser.where(gravatar_url: nil).each do |user|
    client = Octokit::Client.new(:access_token => ENV["GITHUB_ACCESS_TOKEN"])
    gh_user = client.user(user.login)
    gravatar_url = gh_user.avatar_url

    user.update(gravatar_url: gravatar_url)
  end
end

task :update_index do
  last_processed_countie = ''

  begin
    File.open(File.join(__dir__, 'uk_counties.txt')).each_line do |countie|
      countie = countie.gsub(/\n/,'')

      last_processed_countie = countie
      p "Now processing #{countie}"
      search = Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy)
        .at("#{countie}, UK")

      candidates = search.all
      p "#{countie} users count: #{candidates.count}"
      RecruiterExtensions::GithubSearchIndexUpdater.new(candidates).perform
    end
  rescue Exception
    puts "Damn it! I stopped at #{last_processed_countie}"
  end
end

task :fix_geolocations do
  users_with_faulty_geolocation = RecruiterExtensions::IndexedUser.where(geolocation: ",")
  users_with_faulty_geolocation.each do |user|
    user.update(geolocation: ::Geokit::Geocoders::MapboxGeocoder.geocode(user.location).ll)
  end
end
