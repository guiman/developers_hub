class CreateDevRecruiters < ActiveRecord::Migration
  def change
    create_table :dev_recruiters do |t|
      t.string :name
      t.string :uid, null: false
      t.string :avatar_url
      t.string :token
      t.string :email
      t.string :location, default: 'unknown'

      t.timestamps null: false
    end
  end
end
