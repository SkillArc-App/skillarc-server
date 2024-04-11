class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_notifications, id: :uuid do |t|
      t.text :user_id, null: false, index: true
      t.string :body
      t.string :title
      t.string :url
      t.datetime :read_at

      t.timestamps
    end
  end
end
