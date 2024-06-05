class AddFactCoachActionDimUserConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :analytics_fact_coach_actions, "analytics_dim_users_id IS NOT NULL", name: "analytics_dim_users_id_null", validate: false
  end
end
