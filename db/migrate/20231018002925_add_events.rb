class AddEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: :uuid do |t|
      t.string :aggregate_id, null: false
      t.string :event_type, null: false
      t.jsonb :data, null: false, default: {}
      t.jsonb :metadata, null: false, default: {}
      t.integer :version, null: false, default: 0
      t.datetime :occurred_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :events, [:aggregate_id, :version], unique: true
    add_index :events, :event_type
  end
end
