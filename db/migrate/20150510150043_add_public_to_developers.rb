class AddPublicToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :public, :boolean, default: false
  end
end
