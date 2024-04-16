class CreateScheduledCommands < ActiveRecord::Migration[7.1]
  def change
    create_table :infastructure_scheduled_commands do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.uuid :task_id, index: true, null: false
      t.datetime :execute_at, index: true, null: false
      t.string :state, index: true, null: false
      t.jsonb :message, null: false
    end
  end
end
