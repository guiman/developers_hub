class RemoveOfferTable < ActiveRecord::Migration
  def change
    remove_foreign_key "offers", "dev_recruiters"
    remove_foreign_key "offers", "developers"

    remove_index "offers", ["dev_recruiter_id"]
    remove_index "offers", ["developer_id"]

    drop_table :offers
  end
end
