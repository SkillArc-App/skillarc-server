class CreatePeopleSearchAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :people_search_attributes do |t|
      t.uuid :attribute_id, index: true, null: false
      t.text :value, index: true, null: false
    end
  end
end
