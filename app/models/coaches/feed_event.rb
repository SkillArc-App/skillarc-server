# == Schema Information
#
# Table name: coaches_feed_events
#
#  id           :bigint           not null, primary key
#  description  :text             not null
#  occurred_at  :datetime         not null
#  person_email :string
#  person_phone :string
#  person_id    :uuid
#
module Coaches
  class FeedEvent < ApplicationRecord
  end
end
