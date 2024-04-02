class AddSeekerCapturedAtToCoachSeekerContext < ActiveRecord::Migration[7.1]
  def change
    add_column :coach_seeker_contexts, :seeker_captured_at, :datetime
  end
end
