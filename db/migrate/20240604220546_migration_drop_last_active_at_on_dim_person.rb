class MigrationDropLastActiveAtOnDimPerson < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :analytics_dim_people, :last_active_at } # rubocop:disable Rails/ReversibleMigration
  end
end
