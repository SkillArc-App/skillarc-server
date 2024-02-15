class CreateEmployersJobOwners < ActiveRecord::Migration[7.0]
  def change
    create_table :employers_job_owners, id: :uuid do |t|
      t.references :employers_recruiter, type: :uuid, null: false, foreign_key: true
      t.references :employers_job, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
