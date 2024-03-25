class CreateCoachesFeedEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_feed_events do |t|
      t.string :context_id, null: false
      t.string :seeker_email, null: false

      t.text :description, null: false

      t.datetime :occurred_at, null: false

      t.timestamps
    end
  end
end
