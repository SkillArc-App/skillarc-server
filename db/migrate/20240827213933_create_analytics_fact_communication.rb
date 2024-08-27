class CreateAnalyticsFactCommunication < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_fact_communications do |t|
      t.references :analytics_dim_people, foreign_key: true, null: false
      t.references :analytics_dim_users, foreign_key: true, null: false
      t.datetime :occurred_at, null: false
      t.string :kind, null: false
      t.string :direction, null: false
    end
  end
end
