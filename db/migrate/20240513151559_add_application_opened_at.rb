class AddApplicationOpenedAt < ActiveRecord::Migration[7.1]
  def change
    add_column :job_orders_applications, :opened_at, :datetime
  end
end
