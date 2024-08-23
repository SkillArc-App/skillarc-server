class CreateCoachesContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_contacts do |t|
      t.references :coaches_person_context, foreign_key: true, type: :uuid
      t.text :note, null: false
      t.string :contact_direction, null: false
      t.string :contact_type, null: false
      t.datetime :contacted_at, null: false
    end
  end
end
