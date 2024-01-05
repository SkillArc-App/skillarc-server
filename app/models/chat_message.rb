# == Schema Information
#
# Table name: chat_messages
#
#  id                :uuid             not null, primary key
#  applicant_chat_id :uuid             not null
#  user_id           :text             not null
#  message           :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class ChatMessage < ApplicationRecord
  belongs_to :applicant_chat
  belongs_to :user

  has_many :read_receipts
end
