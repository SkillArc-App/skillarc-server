class AddStatusAsOfToEmployersApplicants < ActiveRecord::Migration[7.0]
  def change
    add_column :employers_applicants, :status_as_of, :datetime
  end
end
