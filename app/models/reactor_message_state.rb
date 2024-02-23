# == Schema Information
#
# Table name: reactor_message_states
#
#  id               :bigint           not null, primary key
#  consumer_name    :string           not null
#  message_checksum :uuid             not null
#  state            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  reactor_message_state_index  (consumer_name,message_checksum) UNIQUE
#
class ReactorMessageState < ApplicationRecord
  module Status
    ALL = [
      NEW = "new".freeze,
      DONE = "done".freeze
    ].freeze
  end

  def new?
    state == Status::NEW
  end

  def done?
    state == Status::DONE
  end
end
