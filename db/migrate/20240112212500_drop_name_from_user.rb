class DropNameFromUser < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :users, :name } # rubocop:disable Rails/ReversibleMigration
  end
end
