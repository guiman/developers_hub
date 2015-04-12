class AddDeveloperSkillsCountColumnInDevelopers < ActiveRecord::Migration
  def self.up
    add_column :developers, :developer_skills_count, :integer, :default => 0
    Developer.reset_column_information
    Developer.all.map(&:id).each { |id| Developer.reset_counters(id, :developer_skills) }
  end

  def self.down
    remove_column :developers, :developer_skills_count
  end
end
