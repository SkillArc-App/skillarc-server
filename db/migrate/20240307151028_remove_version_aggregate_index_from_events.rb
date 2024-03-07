class RemoveVersionAggregateIndexFromEvents < ActiveRecord::Migration[7.1]
  def change
    remove_index :events, name: 'index_events_on_aggregate_id_and_version' # rubocop:disable Rails/ReversibleMigration
  end
end
