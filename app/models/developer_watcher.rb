class DeveloperWatcher < ActiveRecord::Base
  belongs_to :developer
  belongs_to :dev_recruiter
end
