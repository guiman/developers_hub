class AddGravatarUrlToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :gravatar_url, :string
  end
end
