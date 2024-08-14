class DropInterests < ActiveRecord::Migration[7.1]
  def change
    drop_table :interests_interests # rubocop:disable Rails/ReversibleMigration
  end
end
