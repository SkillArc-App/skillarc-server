class CreateEmployersEmployers < ActiveRecord::Migration[7.0]
  def change
    create_table :employers_employers, id: :uuid do |t|
      t.string :name, null: false
      t.string :location
      t.string :bio, null: false
      t.string :logo_url

      t.string :employer_id, null: false

      t.timestamps
    end
  end
end
