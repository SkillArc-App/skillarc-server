class CreateJobOrderJobOrder < ActiveRecord::Migration[7.1]
  def change
    create_table :job_orders_job_orders, id: :uuid do |t|
      t.references :job_orders_jobs, type: :uuid, null: false, foreign_key: true
      t.integer :candidate_count, null: false
      t.integer :applicant_count, null: false
      t.integer :recommended_count, null: false
      t.integer :hire_count, null: false
      t.integer :order_count
      t.datetime :closed_at

      t.timestamps
    end
  end
end
