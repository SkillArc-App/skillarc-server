class CreatePersonJobRecommendation < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_person_job_recommendations do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :coaches_coaches, null: false, type: :uuid
      t.references :coaches_person_contexts, null: false, type: :uuid
      t.references :coaches_jobs, null: false, type: :uuid
    end
  end
end
