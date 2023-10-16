class AddIndexToSub < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :users, :sub, unique: true, algorithm: :concurrently
  end
end
