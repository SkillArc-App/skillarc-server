class CreateChatMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_messages, id: :uuid do |t|
      t.references :applicant_chat, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :text

      t.text :message, null: false

      t.timestamps
    end
  end
end
