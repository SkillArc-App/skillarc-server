class AddAppliedAtToApplication < ActiveRecord::Migration[7.1]
  def change
    add_column :employers_applicants, :application_submit_at, :datetime
  end
end
