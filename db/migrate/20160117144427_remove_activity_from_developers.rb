class RemoveActivityFromDevelopers < ActiveRecord::Migration
  def change
    remove_column :developers, :activity
    remove_column :developers, :needs_update_activity
  end
end
