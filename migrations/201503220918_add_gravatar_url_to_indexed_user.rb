class AddGravatarUrlToIndexedUser < ActiveRecord::Migration
  def self.up
    add_column :indexed_users, :gravatar_url, :string
  end

  def self.down
    remove_column :indexed_users, :gravatar_url, :string
  end
end
