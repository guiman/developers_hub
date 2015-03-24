class CreateDeveloperUserTable < ActiveRecord::Migration
  def self.up
    create_table :developer_users do |t|
      t.string :uid
      t.string :github_token
      t.string :github_login
    end
  end

  def self.down
    drop_table :developer_users
  end
end
