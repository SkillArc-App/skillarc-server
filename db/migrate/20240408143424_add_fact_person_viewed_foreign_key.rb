class AddFactPersonViewedForeignKey < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :analytics_fact_person_vieweds, :analytics_dim_people, column: :analyitics_dim_person_viewed_id, validate: false
    add_foreign_key :analytics_fact_person_vieweds, :analytics_dim_people, column: :analyitics_dim_person_viewer_id, validate: false
  end
end
