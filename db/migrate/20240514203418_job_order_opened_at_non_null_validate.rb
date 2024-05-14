class JobOrderOpenedAtNonNullValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :job_orders_job_orders, name: "job_orders_opened_at_null"
    change_column_null :job_orders_job_orders, :opened_at, false
    remove_check_constraint :job_orders_job_orders, name: "job_orders_opened_at_null"
  end
end
