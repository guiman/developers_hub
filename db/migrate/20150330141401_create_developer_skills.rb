class CreateDeveloperSkills < ActiveRecord::Migration
  def change
    create_table :developer_skills do |t|
      t.references :developer, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true
      t.integer :strength
    end
  end
end
