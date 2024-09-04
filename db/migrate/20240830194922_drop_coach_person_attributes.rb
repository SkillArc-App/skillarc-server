class DropCoachPersonAttributes < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_person_attributes # rubocop:disable Rails/ReversibleMigration
  end
end
