class DropUserContact < ActiveRecord::Migration[7.1]
  def change
    drop_table :contact_user_contacts # rubocop:disable Rails/ReversibleMigration
  end
end
