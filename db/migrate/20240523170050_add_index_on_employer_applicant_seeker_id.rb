class AddIndexOnEmployerApplicantSeekerId < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :employers_applicants, :seeker_id, algorithm: :concurrently
  end
end
