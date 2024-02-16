class AddResponseToApplicantStatusReason < ActiveRecord::Migration[7.0]
  def change
    add_column :applicant_status_reasons, :response, :string
  end
end
