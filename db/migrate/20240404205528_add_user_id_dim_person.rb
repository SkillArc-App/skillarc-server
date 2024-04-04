class AddUserIdDimPerson < ActiveRecord::Migration[7.1]
  def change
    add_column :analytics_dim_people, :user_id, :text
  end
end
