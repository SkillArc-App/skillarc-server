class AddMoreColumnsToAnalyticsApplication < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :analytics_fact_applications, bulk: true do |t|
        t.string :employer_name
        t.string :employment_title
        t.datetime :application_updated_at
      end
    end
  end
end
