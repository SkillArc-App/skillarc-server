class MakeSeekerUserIdNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :seekers, :user_id, true
  end
end
