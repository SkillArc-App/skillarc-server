class CreateEmployersJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :employers_jobs, id: :uuid do |t|
      t.string :job_id, null: false
      t.string :employment_title, null: false
      t.string :benefits_description, null: false
      t.string :employment_type, null: false
      t.boolean :hide_job, null: false, default: false
      t.string :industry, array: true, default: []
      t.string :location, null: false
      t.string :requirements_description
      t.string :responsibilities_description
      t.string :schedule
      t.string :work_days

      t.references :employers_employer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
