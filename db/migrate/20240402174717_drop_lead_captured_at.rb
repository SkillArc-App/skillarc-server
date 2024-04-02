class DropLeadCapturedAt < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :coach_seeker_contexts, :lead_captured_at, :datetime }
  end
end
