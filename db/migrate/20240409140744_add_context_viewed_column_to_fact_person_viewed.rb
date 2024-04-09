class AddContextViewedColumnToFactPersonViewed < ActiveRecord::Migration[7.1]
  def change
    add_column :analytics_fact_person_vieweds, :viewing_context, :string
  end
end
