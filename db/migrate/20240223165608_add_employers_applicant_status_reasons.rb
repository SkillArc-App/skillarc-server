class AddEmployersApplicantStatusReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :employers_applicant_status_reasons, id: :uuid do |t|
      t.references :employers_applicant, null: false, foreign_key: true, type: :uuid, index: { name: "index_emp_applicant_status_reasons_on_emp_applicant_id" }
      t.string :reason, null: false
      t.string :response

      t.timestamps
    end
  end
end
