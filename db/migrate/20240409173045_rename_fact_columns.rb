class RenameFactColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :analytics_fact_coach_actions, :analyitics_dim_person_executor_id, :analytics_dim_person_executor_id
    rename_column :analytics_fact_coach_actions, :analyitics_dim_person_target_id, :analytics_dim_person_target_id
    rename_column :analytics_fact_person_vieweds, :analyitics_dim_person_viewed_id, :analytics_dim_person_viewed_id
    rename_column :analytics_fact_person_vieweds, :analyitics_dim_person_viewer_id, :analytics_dim_person_viewer_id
  end
end
