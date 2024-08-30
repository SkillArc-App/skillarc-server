class RecreateAttributesAgain < ActiveRecord::Migration[7.1]
  def change
    create_table :attributes_attributes, id: :uuid do |t|
      t.jsonb :default, null: false
      t.jsonb :set, null: false
      t.text :description
      t.boolean :machine_derived, null: false, default: false
      t.string :name, null: false
    end
  end
end
