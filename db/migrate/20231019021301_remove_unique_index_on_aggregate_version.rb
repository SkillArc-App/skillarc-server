class RemoveUniqueIndexOnAggregateVersion < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    remove_index :events, [:aggregate_id, :version], unique: true
    add_index :events, [:aggregate_id, :version], unique: false, algorithm: :concurrently
  end
end
