class JobOrderStatusNonNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :job_orders_job_orders, "status IS NOT NULL", name: "job_orders_status_null", validate: false
  end
end
