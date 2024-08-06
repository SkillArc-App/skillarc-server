class DropPeopleSearchCoach < ActiveRecord::Migration[7.1]
  def change
    drop_table :people_search_coaches # rubocop:disable Rails/ReversibleMigration
  end
end
