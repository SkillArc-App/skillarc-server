class DropReadReceipts < ActiveRecord::Migration[7.1]
  def change
    drop_table :read_receipts # rubocop:disable Rails/ReversibleMigration
  end
end
