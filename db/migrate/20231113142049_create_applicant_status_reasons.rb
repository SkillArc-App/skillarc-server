class CreateApplicantStatusReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :applicant_status_reasons, id: :uuid do |t|
      t.references :applicant_status, null: false, foreign_key: true, type: :text
      t.references :reason, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
