class OrganizationSkill < ActiveRecord::Base
  belongs_to :organization, counter_cache: true
  belongs_to :skill

  validates :organization, presence: true
  validates :skill, presence: true
end
