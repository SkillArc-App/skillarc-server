class CreateMessageState < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_message_states do |t|
      t.uuid :message_id, null: false, index: { unique: true }
      t.datetime :message_enqueued_at, null: false
      t.datetime :message_terminated_at
      t.string :state, null: false

      t.timestamps
    end
  end
end
