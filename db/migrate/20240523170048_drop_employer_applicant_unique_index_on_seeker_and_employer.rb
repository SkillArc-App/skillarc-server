class DropEmployerApplicantUniqueIndexOnSeekerAndEmployer < ActiveRecord::Migration[7.1]
  def change
    remove_index :employers_applicants, name: "index_employers_applicants_on_seeker_id_and_employers_job_id" # rubocop:disable Rails/ReversibleMigration
  end
end
