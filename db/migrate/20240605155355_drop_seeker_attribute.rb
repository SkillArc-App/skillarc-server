class DropSeekerAttribute < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_seeker_attributes # rubocop:disable Rails/ReversibleMigration
  end
end
