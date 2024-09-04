class CreatePeopleSearchAttributesPeopleAgain2 < ActiveRecord::Migration[7.1]
  def change
    create_table :people_search_attributes_people, id: false do |t|
      t.references :person, foreign_key: { to_table: :people_search_people, on_delete: :cascade }, type: :uuid, null: false
      t.references :attribute, foreign_key: { to_table: :people_search_attributes, on_delete: :cascade }, null: false
      t.uuid :id, null: false, index: true
    end
  end
end
