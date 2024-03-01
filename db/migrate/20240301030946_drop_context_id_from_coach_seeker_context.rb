class DropContextIdFromCoachSeekerContext < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :coach_seeker_contexts, :context_id, :uuid }
  end
end
