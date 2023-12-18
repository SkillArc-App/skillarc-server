class CreateListenerBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :listener_bookmarks do |t|
      t.string :consumer_name, null: false
      t.uuid :event_id, null: false

      t.timestamps
    end
  end
end
