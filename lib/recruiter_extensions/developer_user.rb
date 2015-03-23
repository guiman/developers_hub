require 'active_record'

module RecruiterExtensions
  class DeveloperUser < ActiveRecord::Base
    def self.find_or_create_from_auth_hash(auth)
      # find
      user = self.find_by_uid(auth.uid)

      unless user
        # or create
        user = self.create(uid: auth.uid,
          github_token: auth.credentials.token,
          github_login: auth.extra.raw_info.login)
      end

      user
    end
  end
end
