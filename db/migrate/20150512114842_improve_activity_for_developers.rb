class ImproveActivityForDevelopers < ActiveRecord::Migration
  def change
    remove_column :developers, :pull_request_events, :text
    remove_column :developers, :push_events, :text
    add_column :developers, :activity, :text
  end
end
