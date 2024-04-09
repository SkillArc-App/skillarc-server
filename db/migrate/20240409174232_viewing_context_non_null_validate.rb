class ViewingContextNonNullValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :analytics_fact_person_vieweds, name: "viewing_context_column_null"
    change_column_null :analytics_fact_person_vieweds, :viewing_context, false
    remove_check_constraint :analytics_fact_person_vieweds, name: "viewing_context_column_null"
  end
end
