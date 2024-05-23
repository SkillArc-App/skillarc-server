class DropApplicantUniqueIndexOnSeekerAndJob < ActiveRecord::Migration[7.1]
  def change
    remove_index :applicants, name: "index_applicants_on_seeker_id_and_job_id" # rubocop:disable Rails/ReversibleMigration
  end
end
