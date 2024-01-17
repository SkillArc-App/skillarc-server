class AddNoteTakenByToSeekerNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :seeker_notes, :note_taken_by, :text, null: false
  end
end
