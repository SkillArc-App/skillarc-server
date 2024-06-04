class AddForeignKeyToDimUser < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      add_reference :analytics_dim_people, :analytics_dim_user, foreign_key: true, null: true

      remove_column :analytics_dim_people, :user_id # rubocop:disable Rails/ReversibleMigration
      remove_column :analytics_dim_people, :user_created_at # rubocop:disable Rails/ReversibleMigration

      add_index :analytics_dim_people, :person_id
    end
  end
end
