class AddFactCoachActionDimUserValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :analytics_fact_coach_actions, name: "analytics_dim_users_id_null"

    # in Postgres 12+, you can then safely set NOT NULL on the column
    change_column_null :analytics_fact_coach_actions, :analytics_dim_users_id, false
    remove_check_constraint :analytics_fact_coach_actions, name: "analytics_dim_users_id_null"
  end
end
