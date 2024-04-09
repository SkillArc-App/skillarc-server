class AddOccurredAtIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :events, :occurred_at, algorithm: :concurrently
  end
end
