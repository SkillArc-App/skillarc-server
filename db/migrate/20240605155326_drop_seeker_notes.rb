class DropSeekerNotes < ActiveRecord::Migration[7.1]
  def change
    drop_table :seeker_notes
  end
end
