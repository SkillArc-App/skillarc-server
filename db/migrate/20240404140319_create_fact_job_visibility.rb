class CreateFactJobVisibility < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_fact_job_visibilities do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :analytics_dim_job, index: true, foreign_key: true, null: false
      t.datetime :visible_starting_at, null: false
      t.datetime :visible_ending_at
    end
  end
end
