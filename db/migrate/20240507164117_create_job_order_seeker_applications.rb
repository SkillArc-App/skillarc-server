class CreateJobOrderSeekerApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :job_orders_applications, id: :uuid do |t|
      t.references :job_orders_jobs, type: :uuid, null: false, foreign_key: true
      t.references :job_orders_seekers, type: :uuid, null: false, foreign_key: true
      t.string :status, null: false

      t.timestamps
    end
  end
end
