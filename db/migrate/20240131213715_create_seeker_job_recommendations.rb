class CreateSeekerJobRecommendations < ActiveRecord::Migration[7.0]
  def change
    create_table :coaches_seeker_job_recommendations, id: :uuid do |t|
      t.references :coach_seeker_context, null: false, foreign_key: true, type: :uuid, index: { name: "index_seeker_job_recommendations_on_coach_seeker_context_id" }
      t.references :coach, null: false, foreign_key: true, type: :uuid
      t.references :job, null: false, foreign_key: { to_table: :coaches_jobs }, type: :uuid

      t.timestamps
    end
  end
end
