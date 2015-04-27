class AddOriginToDeveloperSkills < ActiveRecord::Migration
  def change
    add_column :developer_skills, :origin, :string, default: 'github'
  end
end
