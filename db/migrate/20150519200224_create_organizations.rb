class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :email
      t.string :location
      t.string :geolocation
      t.string :login
      t.string :name
      t.string :gravatar_url
      t.text :activity
      t.text :members

      t.timestamps
    end
  end
end
