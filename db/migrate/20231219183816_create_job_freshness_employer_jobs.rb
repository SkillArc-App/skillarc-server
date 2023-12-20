class CreateJobFreshnessEmployerJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :job_freshness_employer_jobs do |t|
      t.string :employer_id, null: false
      t.boolean :recruiter_exists, null: false, default: false
      t.string :jobs, array: true, default: [], null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
