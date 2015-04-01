class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :developer, index: true, foreign_key: true
      t.references :dev_recruiter, index: true, foreign_key: true
      t.string :status, default: "pending", null: false

      t.timestamps null: false
    end
  end
end
