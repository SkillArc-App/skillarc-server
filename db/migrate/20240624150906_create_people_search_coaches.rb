class CreatePeopleSearchCoaches < ActiveRecord::Migration[7.1]
  def change
    create_table :people_search_coaches, id: :uuid do |t|
      t.string :email, null: false
    end
  end
end
