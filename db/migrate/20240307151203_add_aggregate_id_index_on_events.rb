class AddAggregateIdIndexOnEvents < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :events, :aggregate_id, algorithm: :concurrently
  end
end
