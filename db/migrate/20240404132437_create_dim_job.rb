class CreateDimJob < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_dim_jobs do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.datetime :job_created_at, null: false
      t.uuid :job_id, null: false, index: true
      t.string :category, null: false
      t.string :employment_type, null: false, index: true
      t.string :employment_title, null: false
    end
  end
end
