class AddPushEventsToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :push_events, :text
  end
end
