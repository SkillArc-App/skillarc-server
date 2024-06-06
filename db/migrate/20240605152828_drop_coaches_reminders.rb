class DropCoachesReminders < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_reminders # rubocop:disable Rails/ReversibleMigration
  end
end
