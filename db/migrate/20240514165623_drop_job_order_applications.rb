class DropJobOrderApplications < ActiveRecord::Migration[7.1]
  def change
    drop_table :job_orders_applications # rubocop:disable Rails/ReversibleMigration
  end
end
