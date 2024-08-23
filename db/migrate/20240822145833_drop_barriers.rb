class DropBarriers < ActiveRecord::Migration[7.1]
  def change
    drop_table :barriers # rubocop:disable Rails/ReversibleMigration
  end
end
