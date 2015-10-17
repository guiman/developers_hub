class CreateDeveloperWatchers < ActiveRecord::Migration
  def change
    create_table :developer_watchers do |t|
      t.integer :developer_id
      t.integer :dev_recruiter_id

      t.timestamps null: false
    end
  end
end
