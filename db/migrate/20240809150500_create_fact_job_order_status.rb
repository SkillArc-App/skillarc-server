class CreateFactJobOrderStatus < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_fact_job_order_statuses do |t|
      t.references :analytics_dim_job_orders, foreign_key: true, null: false
      t.string :status, null: false
      t.datetime :status_started, null: false
      t.datetime :status_ended
    end
  end
end
