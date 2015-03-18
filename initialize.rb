require 'bundler'
Bundler.require

extension_lib = File.join(__dir__, 'lib')
$:.unshift(extension_lib) unless $:.include?(extension_lib)

require 'recruiter'
require 'recruiter/cached_search_strategy'

require 'active_record'
require 'migration_loader'
require 'recruiter_extensions'

# Setup Faraday to use cache and so Octokit becomes faster
stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, shared_cache: false, serializer: Marshal
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Octokit.middleware = stack

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "",
  :database => "recruiter_index_development"
)

# Yay! Migrations Rails style!
# migrations = MigrationLoader.migrations(File.join(__dir__, 'migrations', '*.rb'))
# migrations.map { |pair| pair.last }.each(&:down)
# migrations.map { |pair| pair.last }.each(&:up)
