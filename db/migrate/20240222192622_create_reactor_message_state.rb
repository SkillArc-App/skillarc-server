class CreateReactorMessageState < ActiveRecord::Migration[7.0]
  def change
    create_table :reactor_message_states do |t|
      t.uuid "message_checksum", null: false
      t.string "consumer_name", null: false
      t.string "state", null: false

      t.timestamps
    end

    add_index :reactor_message_states, %i[consumer_name message_checksum], name: 'reactor_message_state_index', unique: true
  end
end
