class AddEventTypeAndVersionIndexOnEvents < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :events, %i[event_type version], algorithm: :concurrently
  end
end
