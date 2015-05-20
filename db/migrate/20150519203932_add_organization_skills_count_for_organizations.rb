class AddOrganizationSkillsCountForOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :organization_skills_count, :integer, :default => 0
    Organization.reset_column_information
    Organization.all.map(&:id).each { |id| Organization.reset_counters(id, :organization_skills) }
  end

  def self.down
    remove_column :organizations, :organization_skills_count
  end
end
