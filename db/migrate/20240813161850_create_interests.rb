class CreateInterests < ActiveRecord::Migration[7.1]
  def change
    create_table :interests_interests do |t|
      t.string :interests, null: false, array: true
    end
  end
end
