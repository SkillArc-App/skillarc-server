class CreatePersonAttribute < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_person_attributes, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :coaches_person_context, null: false, type: :uuid
      t.uuid :attribute_id, null: false
      t.string :name, null: false
      t.string :values, array: true, default: []
    end
  end
end
