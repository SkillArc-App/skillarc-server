class MakeBookmarkEventIdNullable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :listener_bookmarks, :event_id, true
  end
end
