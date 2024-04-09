class ViewingContextNonNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :analytics_fact_person_vieweds, "viewing_context IS NOT NULL", name: "viewing_context_column_null", validate: false
  end
end
