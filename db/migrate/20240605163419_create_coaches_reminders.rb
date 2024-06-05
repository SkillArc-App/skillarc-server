class CreateCoachesReminders < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_reminders, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :coaches_coaches, null: false, type: :uuid
      t.text :note, null: false
      t.datetime :reminder_at, null: false
      t.string :state, null: false
      t.uuid :message_task_id, null: false
      t.uuid :person_id
    end
  end
end
