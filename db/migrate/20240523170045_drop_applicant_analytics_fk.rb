class DropApplicantAnalyticsFk < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :applicant_analytics, :applicants
  end
end
