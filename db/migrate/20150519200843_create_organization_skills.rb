class CreateOrganizationSkills < ActiveRecord::Migration
  def change
    create_table :organization_skills do |t|
      t.references :organization, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true
      t.integer :strength
    end
  end
end
