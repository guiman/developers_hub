class MakeRecruitersBetaByDefault < ActiveRecord::Migration
  def change
    change_column :dev_recruiters, :beta_user, :boolean, default: true
  end
end
