class AddIndexOnApplicantJobId < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :applicants, :job_id, algorithm: :concurrently
  end
end
