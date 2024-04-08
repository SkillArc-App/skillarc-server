class ValidateFactPersonViewedForeignKey < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :analytics_fact_person_vieweds, column: :analyitics_dim_person_viewed_id
    validate_foreign_key :analytics_fact_person_vieweds, column: :analyitics_dim_person_viewer_id
  end
end
