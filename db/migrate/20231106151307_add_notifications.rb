class AddNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :type
      t.string :title
      t.string :body
      t.string :url

      t.references :user, null: false, foreign_key: true, type: :text
      t.datetime :read_at

      t.timestamps
    end
  end
end
