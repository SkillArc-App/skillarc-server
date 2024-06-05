class AddKindToDimUser < ActiveRecord::Migration[7.1]
  def change
    add_column :analytics_dim_users, :kind, :string # rubocop:disable Rails/BulkChangeTable
    add_column :analytics_dim_users, :coach_id, :uuid
  end
end
