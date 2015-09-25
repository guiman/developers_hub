require 'cucumber/rails'

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Before('@omniauth_test') do
  OmniAuth.config.test_mode = true
  Capybara.default_host = 'http://example.com'

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

After('@omniauth_test') do
  OmniAuth.config.test_mode = false
end

Before('@hireable_js_dev') do
  dev_1 = Developer.create(login: "hireable dev", hireable: true)
  dev_1.skills << Skill.find_or_create_by(name: "JavaScript")
end

Before('@non_hireable_js_dev') do
  dev_1 = Developer.create(login: "non hireable dev", hireable: false)
  dev_1.skills << Skill.find_or_create_by(name: "JavaScript")
end

Before('@hireable_ruby_dev') do
  dev_1 = Developer.create(login: "hireable dev", hireable: true)
  dev_1.skills << Skill.find_or_create_by(name: "Ruby")
end
