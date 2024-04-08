class AddFactCoachActionForeignKey < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :analytics_fact_coach_actions, :analytics_dim_people, column: :analyitics_dim_person_executor_id, validate: false
    add_foreign_key :analytics_fact_coach_actions, :analytics_dim_people, column: :analyitics_dim_person_target_id, validate: false
  end
end
