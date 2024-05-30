class DropApplicantAnalytic < ActiveRecord::Migration[7.1]
  def change
    drop_table :applicant_analytics # rubocop:disable Rails/ReversibleMigration
  end
end
