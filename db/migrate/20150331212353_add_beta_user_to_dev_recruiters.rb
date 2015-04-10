class AddBetaUserToDevRecruiters < ActiveRecord::Migration
  def change
    add_column :dev_recruiters, :beta_user, :boolean, default: false, null: false
  end
end
