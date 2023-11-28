class CreateReadReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :read_receipts, id: :uuid do |t|
      t.references :chat_message, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :text
      t.datetime :read_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    
      t.timestamps
    end
  end
end
