class DropFeedEvent < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_feed_events # rubocop:disable Rails/ReversibleMigration
  end
end
