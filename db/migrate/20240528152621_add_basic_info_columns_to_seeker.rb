class AddBasicInfoColumnsToSeeker < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :seekers, bulk: true do |t|
        t.column :first_name, :string
        t.column :last_name, :string
        t.column :email, :string
        t.column :phone_number, :string
        t.column :zip_code, :string
      end
    end
  end
end
