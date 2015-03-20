require_relative 'initialize'
require_relative 'lib/migration_loader'

task :migrate_up do
  migrations = MigrationLoader.migrations(File.join(__dir__, 'migrations', '*.rb'))
  migrations.map { |pair| pair.last }.each(&:up)
end

task :migrate_down do
  migrations = MigrationLoader.migrations(File.join(__dir__, 'migrations', '*.rb'))
  migrations.map { |pair| pair.last }.each(&:down)
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
