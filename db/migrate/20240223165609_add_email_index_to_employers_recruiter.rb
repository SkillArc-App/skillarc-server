class AddEmailIndexToEmployersRecruiter < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :employers_recruiters, :email, unique: true, algorithm: :concurrently
  end
end
