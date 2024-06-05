class CreateCoachesPersonNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_person_notes, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :coaches_person_context, null: false, type: :uuid
      t.text :note, null: false
      t.datetime :note_taken_at, null: false
      t.string :note_taken_by, null: false
    end
  end
end
