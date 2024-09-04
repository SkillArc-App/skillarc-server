class CreatePeopleSearchAttributesAgain < ActiveRecord::Migration[7.1]
  def change
    create_table :people_search_attributes do |t|
      t.uuid :attribute_id, index: true, null: false
      t.uuid :attribute_value_id, index: true, null: false
    end
  end
end
