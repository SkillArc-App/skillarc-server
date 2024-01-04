class CreateJobFreshnessContexts < ActiveRecord::Migration[7.0]
  def change
    create_table :job_freshness_contexts, id: :uuid do |t|
      t.jsonb :applicants, null: false, default: {}
      t.string :employer_name, null: false
      t.string :employment_title, null: false
      t.boolean :hidden, null: false, default: false
      t.uuid :job_id, null: false
      t.boolean :recruiter_exists, null: false, default: false

      t.string :status, null: false, default: "fresh"

      t.timestamps
    end
  end
end
