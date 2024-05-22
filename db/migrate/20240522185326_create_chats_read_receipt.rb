class CreateChatsReadReceipt < ActiveRecord::Migration[7.1]
  def change
    create_table :chats_read_receipts do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :chats_applicant_chats, null: false, foreign_key: true
      t.string :user_id, null: false, index: true
      t.datetime :read_until, null: false
    end
  end
end
