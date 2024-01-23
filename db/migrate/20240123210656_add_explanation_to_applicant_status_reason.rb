class AddExplanationToApplicantStatusReason < ActiveRecord::Migration[7.0]
  def change
    add_column :applicant_status_reasons, :explanation, :string
  end
end
