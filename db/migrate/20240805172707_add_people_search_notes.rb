class AddPeopleSearchNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :people_search_notes, id: :uuid do |t|
      t.references :person, foreign_key: { to_table: :people_search_people, on_delete: :cascade }, type: :uuid, null: false
      t.text :note, null: false
    end
  end
end
