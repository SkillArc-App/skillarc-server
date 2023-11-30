class AddApplicantCreatedAtToApplicantAnalytics < ActiveRecord::Migration[7.0]
  def change
    add_column :applicant_analytics, :applicant_created_at, :datetime
  end
end
