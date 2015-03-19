class CreateIndexedUserTable < ActiveRecord::Migration
  def self.up
    create_table :indexed_users do |t|
      t.string :email
      t.string :location
      t.string :geolocation
      t.string :login
      t.string :name
      t.boolean :hireable
      t.text :languages
    end
  end

  def self.down
    drop_table :indexed_users
  end
end
