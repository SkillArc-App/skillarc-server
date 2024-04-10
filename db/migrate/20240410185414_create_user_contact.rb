class CreateUserContact < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_user_contacts do |t|
      t.uuid :user_id, null: false, index: true
      t.string :preferred_contact, null: false
      t.string :email
      t.string :phone_number
      t.string :slack_id

      t.timestamps
    end
  end
end
