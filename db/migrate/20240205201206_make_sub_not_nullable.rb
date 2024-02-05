class MakeSubNotNullable < ActiveRecord::Migration[7.0]
  def up
    safety_assured do
      change_column :users, :sub, :string, null: false
    end
  end

  def down
    change_column :users, :sub, :string, null: true
  end
end
