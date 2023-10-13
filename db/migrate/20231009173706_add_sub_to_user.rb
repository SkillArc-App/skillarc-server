class AddSubToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sub, :string
  end
end
