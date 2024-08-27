class RecreateCoachesFeedEvent < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_feed_events do |t|
      t.text :description, null: false
      t.datetime :occurred_at, null: false
      t.string :person_email
      t.string :person_phone
      t.uuid :person_id
    end
  end
end
