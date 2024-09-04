class DropAttributes < ActiveRecord::Migration[7.1]
  def change
    drop_table :attributes_attributes # rubocop:disable Rails/ReversibleMigration
  end
end
