class AddLastActiveAtOnDimUser < ActiveRecord::Migration[7.1]
  def change
    add_column :analytics_dim_users, :last_active_at, :datetime
  end
end
