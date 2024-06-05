class DropJobOrderSeekers < ActiveRecord::Migration[7.1]
  def change
    drop_table :job_orders_seekers # rubocop:disable Rails/ReversibleMigration
  end
end
