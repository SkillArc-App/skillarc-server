class CreateCoachPersonAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_person_attributes, id: :uuid do |t|
      t.boolean :machine_derived, null: false, default: false
      t.uuid :attribute_id, null: false
      t.references :coaches_person_context, type: :uuid, foreign_key: true
      t.uuid :attribute_value_ids, null: false, array: true
    end
  end
end
