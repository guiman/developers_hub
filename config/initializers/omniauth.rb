OmniAuth.config.logger = Rails.logger

linkedin_options = {
  scope: 'r_basicprofile r_emailaddress',
  fields: ['id', 'positions', 'email-address', 'first-name', 'last-name', 'headline', 'location', 'industry', 'picture-url', 'public-profile-url', "picture-urls::(original)"]
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], linkedin_options
end
