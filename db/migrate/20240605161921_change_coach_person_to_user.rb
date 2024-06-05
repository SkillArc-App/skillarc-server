class ChangeCoachPersonToUser < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      remove_column :analytics_fact_person_vieweds, :analytics_dim_person_viewer_id # rubocop:disable Rails/ReversibleMigration
      add_reference :analytics_fact_person_vieweds, :analytics_dim_user_viewer
    end
  end
end
