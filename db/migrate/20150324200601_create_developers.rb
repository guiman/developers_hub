class CreateDevelopers < ActiveRecord::Migration
  def change
    create_table :developers do |t|
      t.string :email
      t.string :location
      t.string :geolocation
      t.string :login
      t.string :name
      t.boolean :hireable
      t.text :languages

      t.timestamps null: false
    end
  end
end
