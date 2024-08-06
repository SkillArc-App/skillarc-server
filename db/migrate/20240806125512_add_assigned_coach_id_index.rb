class AddAssignedCoachIdIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :people_search_people, :assigned_coach_id, algorithm: :concurrently
  end
end
