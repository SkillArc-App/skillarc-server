class DropMessageState < ActiveRecord::Migration[7.1]
  def change
    drop_table :contact_message_states # rubocop:disable Rails/ReversibleMigration
  end
end
