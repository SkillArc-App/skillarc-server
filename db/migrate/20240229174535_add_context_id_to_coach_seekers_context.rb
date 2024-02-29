class AddContextIdToCoachSeekersContext < ActiveRecord::Migration[7.1]
  def change
    add_column :coach_seeker_contexts, :context_id, :uuid
  end
end
