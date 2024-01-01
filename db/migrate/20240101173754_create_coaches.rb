class CreateCoaches < ActiveRecord::Migration[7.0]
  def change
    create_table :coaches, id: :uuid do |t|
      t.string :user_id, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
