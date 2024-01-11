class DropNotesColumnOnCoachSeekerContext < ActiveRecord::Migration[7.0]
  def change
    safety_assured {
      remove_column :coach_seeker_contexts, :notes
    }
  end
end
