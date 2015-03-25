require 'recruiter_extensions'
require 'migration_loader'
require 'byebug'

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "",
  :database => "recruiter_index_test"
)

# Yay! Migrations Rails style!
migrations = MigrationLoader.migrations(File.join(__dir__, '../' ,'migrations', '*.rb'))

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:all) do
    migrations.map { |pair| pair.last }.each(&:up)
  end

  config.after(:all) do
    migrations.map { |pair| pair.last }.each(&:down)
  end

  config.after(:each) do
    RecruiterExtensions::IndexedUser.destroy_all
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
