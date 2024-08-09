class DropFactCandidate < ActiveRecord::Migration[7.1]
  def change
    drop_table :analytics_fact_candidates # rubocop:disable Rails/ReversibleMigration
  end
end
