class CreateSubscribersTable< ActiveRecord::Migration
  def self.up
    create_table :subscribers do |t|
      t.string :email
    end
  end

  def self.down
    drop_table :subscribers
  end
end
