class DropSeekerJobRecommendation < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_seeker_job_recommendations # rubocop:disable Rails/ReversibleMigration
  end
end
