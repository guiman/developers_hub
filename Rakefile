require_relative 'lib/migration_loader'
require 'active_record'
require_relative 'database'

task :migrate_up do
  migrations = MigrationLoader.migrations(File.join(__dir__, 'migrations', '*.rb'))
  migrations.map { |pair| pair.last }.each(&:up)
end

task :migrate_down do
  migrations = MigrationLoader.migrations(File.join(__dir__, 'migrations', '*.rb'))
  migrations.map { |pair| pair.last }.each(&:down)
end
