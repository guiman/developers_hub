class DeveloperSkill < ActiveRecord::Base
  belongs_to :developer
  belongs_to :skill

  validates :developer, presence: true
  validates :skill, presence: true
end
