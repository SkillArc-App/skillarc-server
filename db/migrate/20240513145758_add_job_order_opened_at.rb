class AddJobOrderOpenedAt < ActiveRecord::Migration[7.1]
  def change
    add_column :job_orders_job_orders, :opened_at, :datetime
  end
end
