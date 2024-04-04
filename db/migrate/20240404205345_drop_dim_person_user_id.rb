class DropDimPersonUserId < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :analytics_dim_people, :user_id, :uuid }
  end
end
