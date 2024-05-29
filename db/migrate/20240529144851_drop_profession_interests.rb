class DropProfessionInterests < ActiveRecord::Migration[7.1]
  def change
    drop_table :professional_interests # rubocop:disable Rails/ReversibleMigration
  end
end
