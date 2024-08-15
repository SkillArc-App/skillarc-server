class CreateAnalyticsDimDate < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_dim_dates do |t|
      t.date :date, null: false, index: true
      t.datetime :datetime, null: false, index: true
      t.string :day_of_week, null: false
      t.integer :day, null: false
      t.integer :month, null: false
    end
  end
end
