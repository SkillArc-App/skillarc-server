class DropAttributePerson < ActiveRecord::Migration[7.1]
  def change
    drop_table :people_search_attributes_people # rubocop:disable Rails/ReversibleMigration
  end
end
