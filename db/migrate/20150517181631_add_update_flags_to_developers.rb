class AddUpdateFlagsToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :needs_update_activity, :boolean, default: true
    add_column :developers, :needs_update_contributions, :boolean, default: true
  end
end
