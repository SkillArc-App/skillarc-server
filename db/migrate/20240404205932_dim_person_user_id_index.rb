class DimPersonUserIdIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :analytics_dim_people, :user_id, algorithm: :concurrently
  end
end
