class AddIndexOnEmployerApplicantApplicantId < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :employers_applicants, :applicant_id, unique: true, algorithm: :concurrently
  end
end
