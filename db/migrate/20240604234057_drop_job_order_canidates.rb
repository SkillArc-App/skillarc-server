class DropJobOrderCanidates < ActiveRecord::Migration[7.1]
  def change
    drop_table :job_orders_candidates # rubocop:disable Rails/ReversibleMigration
  end
end
