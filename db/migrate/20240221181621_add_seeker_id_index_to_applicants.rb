class AddSeekerIdIndexToApplicants < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :applicants, %i[seeker_id job_id], unique: true, algorithm: :concurrently
    add_index :employers_applicants, %i[seeker_id employers_job_id], unique: true, algorithm: :concurrently
  end
end
