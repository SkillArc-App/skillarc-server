class AddLeadIdToCoachSeekersContext < ActiveRecord::Migration[7.1]
  def change
    add_column :coach_seeker_contexts, :lead_id, :uuid
  end
end
