class CreateCoachesJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :coaches_jobs, id: :uuid do |t|
      t.uuid :job_id, null: false, index: true
      t.string :employment_title, null: false

      t.timestamps
    end
  end
end
