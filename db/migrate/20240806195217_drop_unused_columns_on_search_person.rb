class DropUnusedColumnsOnSearchPerson < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      remove_column :people_search_people, :certified_by, :string
      remove_column :people_search_people, :user_id, :string
    end
  end
end
