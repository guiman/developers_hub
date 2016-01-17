require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'webmock/cucumber'
require 'webmock/rspec'

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Before('@webmock') do
  WebMock.stub_request(:get, /http:\/\/archive-observer\.herokuapp\.com\/.*/).to_return(:body => "",
    :status => 400, :headers => { 'Content-Length' => 3 })
end

Before('@omniauth') do
  OmniAuth.config.test_mode = true
  Capybara.default_host = 'http://example.com'
end

Before('@recruiter') do
  OmniAuth.config.add_mock(:linkedin, {
    uid: '9999',
    extra: {
      raw_info: {
        pictureUrls: {
          values: [ 'something', ['profile_picture'] ]
        }
      }
    },
    info: {
      first_name: 'Example',
      last_name: 'User',
      location: 'Somewhere in a Galaxy far away',
      email: 'test@example.com'
    },
    credentials: { token: '123' }
  })
end

Before('@developer') do
  OmniAuth.config.add_mock(:github, {
    uid: '9999',
    extra: {
      raw_info: {
        login: 'test_user'
      }
    },
    info: {
      first_name: 'Example',
      last_name: 'User',
      location: 'Somewhere in a Galaxy far away',
      email: 'test@example.com'
    },
    credentials: { token: '123' }
  })
end


After('@omniauth') do
  OmniAuth.config.test_mode = false
end

Before('@hireable_js_dev') do
  dev_1 = Developer.create(login: "hireable_dev", hireable: true)
  dev_1.skills << Skill.find_or_create_by(name: "JavaScript")
end

Before('@non_hireable_js_dev') do
  dev_1 = Developer.create(login: "non_hireable_dev", hireable: false)
  dev_1.skills << Skill.find_or_create_by(name: "JavaScript")
end

Before('@hireable_ruby_dev') do
  dev_1 = Developer.create(login: "hireable_dev", hireable: true)
  dev_1.skills << Skill.find_or_create_by(name: "Ruby")
end
