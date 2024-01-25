class AddSeekerIdToCoachSeekersContext < ActiveRecord::Migration[7.0]
  def change
    add_column :coach_seeker_contexts, :seeker_id, :uuid
  end
end
