class AddJobCategoryToJobOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :job_orders_jobs, :applicable_for_job_orders, :boolean
  end
end
