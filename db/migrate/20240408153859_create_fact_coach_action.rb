class CreateFactCoachAction < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    create_table :analytics_fact_coach_actions do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.bigint :analyitics_dim_person_executor_id, null: false
      t.bigint :analyitics_dim_person_target_id
      t.string :action, null: false, index: true
      t.datetime :action_taken_at, null: false
    end

    add_index :analytics_fact_coach_actions, :analyitics_dim_person_executor_id, algorithm: :concurrently
    add_index :analytics_fact_coach_actions, :analyitics_dim_person_target_id, algorithm: :concurrently
  end
end
