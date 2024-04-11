class DropNotificationTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :notifications # rubocop:disable Rails/ReversibleMigration
  end
end
