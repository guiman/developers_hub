class AddPullRequestEventsToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :pull_request_events, :text
  end
end
