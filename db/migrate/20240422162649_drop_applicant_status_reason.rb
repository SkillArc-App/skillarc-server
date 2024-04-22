class DropApplicantStatusReason < ActiveRecord::Migration[7.1]
  def change
    drop_table :applicant_status_reasons
  end
end
