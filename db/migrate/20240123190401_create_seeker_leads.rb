class CreateSeekerLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :coaches_seeker_leads do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone_number, null: false
      t.string :email
      t.string :status, null: false
      t.string :lead_captured_by, null: false
      t.datetime :lead_captured_at, null: false

      t.timestamps
    end

    add_index :coaches_seeker_leads, :email, unique: true
    add_index :coaches_seeker_leads, :phone_number, unique: true
  end
end
