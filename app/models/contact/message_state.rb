# == Schema Information
#
# Table name: contact_message_states
#
#  id                    :bigint           not null, primary key
#  message_enqueued_at   :datetime         not null
#  message_terminated_at :datetime
#  state                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  message_id            :uuid             not null
#
# Indexes
#
#  index_contact_message_states_on_message_id  (message_id) UNIQUE
#
module Contact
  class MessageState < ApplicationRecord
    self.table_name = "contact_message_states"

    validates :state, inclusion: { in: Contact::MessageStates::ALL }

    def complete!(message_terminated_at:)
      return unless state == Contact::MessageStates::ENQUEUED

      update(state: Contact::MessageStates::COMPLETED, message_terminated_at:)
    end
  end
end
