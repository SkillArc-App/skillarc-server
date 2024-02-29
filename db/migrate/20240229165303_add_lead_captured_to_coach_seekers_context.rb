class AddLeadCapturedToCoachSeekersContext < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :coach_seeker_contexts, bulk: true do |t|
        t.datetime :lead_captured_at
        t.string :lead_captured_by
      end
    end
  end
end
