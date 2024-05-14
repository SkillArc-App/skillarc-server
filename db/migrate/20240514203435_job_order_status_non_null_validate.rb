class JobOrderStatusNonNullValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :job_orders_job_orders, name: "job_orders_status_null"
    change_column_null :job_orders_job_orders, :status, false
    remove_check_constraint :job_orders_job_orders, name: "job_orders_status_null"
  end
end
