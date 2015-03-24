class AddSecureReferenceToDeveloper < ActiveRecord::Migration
  def change
    add_column :developers, :secure_reference, :string, null: false
  end
end
