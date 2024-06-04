class AddPersonIdToDimPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :analytics_dim_people, :person_id, :uuid, null: false # rubocop:disable Rails/NotNullColumn
  end
end
