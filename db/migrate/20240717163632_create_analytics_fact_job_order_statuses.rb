class CreateAnalyticsFactJobOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_fact_job_order_statuses do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :analytics_dim_job_order, null: false, foreign_key: true

      t.string :status, null: false
      t.datetime :started_at, null: false
      t.datetime :ended_at
    end
  end
end
