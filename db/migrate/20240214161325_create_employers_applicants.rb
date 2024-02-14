class CreateEmployersApplicants < ActiveRecord::Migration[7.0]
  def change
    create_table :employers_applicants, id: :uuid do |t|
      t.string :applicant_id, null: false
      t.uuid :seeker_id, null: false

      t.string :status, null: false

      t.references :employers_job, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
