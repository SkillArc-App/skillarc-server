class AddAssignedCoachIdColumn < ActiveRecord::Migration[7.1]
  def change
    add_column :people_search_people, :assigned_coach_id, :uuid
  end
end
