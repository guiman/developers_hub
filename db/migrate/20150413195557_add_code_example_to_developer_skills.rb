class AddCodeExampleToDeveloperSkills < ActiveRecord::Migration
  def change
    add_column :developer_skills, :code_example, :string, default: ""
  end
end
