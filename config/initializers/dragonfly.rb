require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "be471aae4db24f807f936499937d977f538f4593320341d5de8729b9f1ff2b20"

  url_format "/media/:job/:name"
  fetch_url_whitelist [ /avatars\.githubusercontent\.com/ ]
  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
