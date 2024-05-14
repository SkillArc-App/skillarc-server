class JobOrderOpenedAtNonNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :job_orders_job_orders, "opened_at IS NOT NULL", name: "job_orders_opened_at_null", validate: false
  end
end
