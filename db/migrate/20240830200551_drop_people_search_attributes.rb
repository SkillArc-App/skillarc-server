class DropPeopleSearchAttributes < ActiveRecord::Migration[7.1]
  def change
    drop_table :people_search_attributes # rubocop:disable Rails/ReversibleMigration
  end
end
