# == Schema Information
#
# Table name: listener_bookmarks
#
#  id            :bigint           not null, primary key
#  consumer_name :string           not null
#  event_id      :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ListenerBookmark < ApplicationRecord
end
