class DropChatMessage < ActiveRecord::Migration[7.1]
  def change
    drop_table :chat_messages # rubocop:disable Rails/ReversibleMigration
  end
end
