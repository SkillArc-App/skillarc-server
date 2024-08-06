class DropUnusedColumnsOnSearchExperience < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      remove_column :people_search_person_experiences, :created_at, :datetime
      remove_column :people_search_person_experiences, :updated_at, :datetime
    end
  end
end
