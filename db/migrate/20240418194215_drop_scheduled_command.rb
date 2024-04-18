class DropScheduledCommand < ActiveRecord::Migration[7.1]
  def change
    drop_table :infrastructure_scheduled_commands # rubocop:disable Rails/ReversibleMigration
  end
end
