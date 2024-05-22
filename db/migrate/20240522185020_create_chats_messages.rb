class CreateChatsMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chats_messages do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :chats_applicant_chats, null: false, foreign_key: true
      t.string :from, null: false
      t.string :user_id
      t.string :message, null: false
      t.datetime :message_sent_at, null: false
    end
  end
end
