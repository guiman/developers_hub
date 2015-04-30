class AddTimestampsToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :created_at, :datetime
    add_column :developers, :updated_at, :datetime
  end
end
