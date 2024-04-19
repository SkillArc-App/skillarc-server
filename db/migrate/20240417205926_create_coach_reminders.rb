class CreateCoachReminders < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_reminders, id: :uuid do |t|
      t.references :coach, type: :uuid, null: false, foreign_key: true
      t.string :context_id
      t.string :note, null: false
      t.string :state, null: false
      t.uuid :message_task_id, null: false
      t.datetime :reminder_at, null: false

      t.timestamps
    end
  end
end
