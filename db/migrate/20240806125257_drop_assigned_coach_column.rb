class DropAssignedCoachColumn < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :people_search_people, :assigned_coach, :string }
  end
end
