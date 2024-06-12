# == Schema Information
#
# Table name: listener_bookmarks
#
#  id                :bigint           not null, primary key
#  consumer_name     :string           not null
#  current_timestamp :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  event_id          :uuid
#
# Indexes
#
#  index_listener_bookmarks_on_consumer_name  (consumer_name) UNIQUE
#
class ListenerBookmark < ApplicationRecord
end
