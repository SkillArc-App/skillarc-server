class CreateFactPersonViewed < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    create_table :analytics_fact_person_vieweds do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.bigint :analyitics_dim_person_viewed_id, null: false
      t.bigint :analyitics_dim_person_viewer_id, null: false
      t.datetime :viewed_at, null: false
    end

    add_index :analytics_fact_person_vieweds, :analyitics_dim_person_viewed_id, algorithm: :concurrently
    add_index :analytics_fact_person_vieweds, :analyitics_dim_person_viewer_id, algorithm: :concurrently
  end
end
