class AddDimUser < ActiveRecord::Migration[7.1]
  def change
    create_table :analytics_dim_users do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :user_id, null: false
      t.string :email, null: false
      t.string :first_name
      t.string :last_name

      t.timestamp :user_created_at, null: false
    end
  end
end
