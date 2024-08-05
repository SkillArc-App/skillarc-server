class DropLastActiveAtPeopleSearch < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      remove_column :people_search_people, :last_active_at, :datetime
      remove_column :people_search_people, :last_contacted_at, :datetime
    end
  end
end
