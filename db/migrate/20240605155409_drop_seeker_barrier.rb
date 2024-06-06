class DropSeekerBarrier < ActiveRecord::Migration[7.1]
  def change
    drop_table :seeker_barriers # rubocop:disable Rails/ReversibleMigration
  end
end
