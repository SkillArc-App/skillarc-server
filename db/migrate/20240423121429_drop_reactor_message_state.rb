class DropReactorMessageState < ActiveRecord::Migration[7.1]
  def change
    drop_table :reactor_message_states # rubocop:disable Rails/ReversibleMigration
  end
end
