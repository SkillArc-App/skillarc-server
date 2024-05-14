class AddCandidateAppliedAt < ActiveRecord::Migration[7.1]
  def change
    add_column :job_orders_candidates, :applied_at, :datetime
  end
end
