class AddStatusReasonToEmployerApplicant < ActiveRecord::Migration[7.1]
  def change
    add_column :employers_applicants, :status_reason, :string
  end
end
