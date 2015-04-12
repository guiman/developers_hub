class DeveloperSkill < ActiveRecord::Base
  belongs_to :developer, counter_cache: true
  belongs_to :skill

  validates :developer, presence: true
  validates :skill, presence: true
end
