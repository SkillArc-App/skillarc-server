class DropApplicantStatusReason < ActiveRecord::Migration[7.1]
  def change
    drop_table :applicant_status_reasons # rubocop:disable Rails/ReversibleMigration
  end
end
