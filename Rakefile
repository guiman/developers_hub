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
  search = Recruiter.search(search_strategy: Recruiter::CachedSearchStrategy)
    .at("Cambridge, UK")

  RecruiterExtensions::GithubSearchIndexUpdater.new(search.all).perform
end
