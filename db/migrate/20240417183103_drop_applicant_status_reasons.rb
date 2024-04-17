class DropApplicantStatusReasons < ActiveRecord::Migration[7.1]
  def change
    drop_table :employers_applicant_status_reasons # rubocop:disable Rails/ReversibleMigration
  end
end
