class AddAddedAtToCandidate < ActiveRecord::Migration[7.1]
  def change
    add_column :job_orders_candidates, :added_at, :datetime
  end
end
