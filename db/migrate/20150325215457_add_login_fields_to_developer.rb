class AddLoginFieldsToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :uid, :string
    add_column :developers, :token, :string
  end
end
