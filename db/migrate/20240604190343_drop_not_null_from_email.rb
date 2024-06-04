class DropNotNullFromEmail < ActiveRecord::Migration[7.1]
  def change
    change_column_null :analytics_dim_users, :email, true
  end
end
