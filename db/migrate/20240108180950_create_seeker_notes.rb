class CreateSeekerNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :seeker_notes, id: :uuid do |t|
      t.references :coach_seeker_context, foreign_key: true, type: :uuid, null: false
      t.uuid :note_id, null: false
      t.string :note, null: false
      t.datetime :note_taken_at, null: false
      t.timestamps
    end
  end
end
