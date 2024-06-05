class DropDimPersonExecutorId < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :analytics_fact_coach_actions, :analytics_dim_person_executor_id, :uuid }
  end
end
