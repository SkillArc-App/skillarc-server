class ValidateFactCoachActionForeignKey < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :analytics_fact_coach_actions, column: :analyitics_dim_person_executor_id
    validate_foreign_key :analytics_fact_coach_actions, column: :analyitics_dim_person_target_id
  end
end
