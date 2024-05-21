class AddOccurredAtToListenerBookmark < ActiveRecord::Migration[7.1]
  def change
    add_column :listener_bookmarks, :current_timestamp, :datetime
  end
end
