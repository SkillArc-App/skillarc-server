class CreateFactApplication < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_fact_applications do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :analytics_dim_job, index: true, foreign_key: true, null: false
      t.references :analytics_dim_person, index: true, foreign_key: true, null: false
      t.uuid :application_id, index: true, null: false
      t.datetime :application_opened_at, null: false
      t.string :status, index: true, null: false
      t.integer :application_number, index: true, null: false
    end
  end
end
