class DeleteTempUsersTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :temp_users
  end
end
