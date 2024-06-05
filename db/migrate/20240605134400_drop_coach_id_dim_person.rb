class DropCoachIdDimPerson < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :analytics_dim_people, :seeker_id, :uuid }
    safety_assured { remove_column :analytics_dim_people, :coach_id, :uuid }
  end
end
