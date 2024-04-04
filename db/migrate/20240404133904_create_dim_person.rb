class CreateDimPerson < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_dim_people do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :first_name
      t.string :last_name
      t.string :phone_number, index: true
      t.string :email, index: true
      t.string :kind, index: true, null: false
      t.datetime :user_created_at
      t.datetime :lead_created_at
      t.datetime :onboarding_completed_at
      t.datetime :last_active_at
      t.uuid :lead_id, index: true
      t.uuid :user_id, index: true
      t.uuid :seeker_id, index: true
      t.uuid :coach_id, index: true
    end
  end
end
