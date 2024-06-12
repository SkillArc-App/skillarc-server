class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.uuid :message_id, index: true, null: false
      t.text :stream, index: true, null: false
      t.text :versioned_type, index: true, null: false
      t.uuid :trace_id, index: true, null: false
      t.datetime :occurred_at, index: true, null: false
      t.jsonb :data, null: false
      t.jsonb :metadata, null: false
    end
  end
end
