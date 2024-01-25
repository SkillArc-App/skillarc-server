# == Schema Information
#
# Table name: chat_messages
#
#  id                :uuid             not null, primary key
#  message           :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  applicant_chat_id :uuid             not null
#  user_id           :text             not null
#
# Indexes
#
#  index_chat_messages_on_applicant_chat_id  (applicant_chat_id)
#  index_chat_messages_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (applicant_chat_id => applicant_chats.id)
#  fk_rails_...  (user_id => users.id)
#
class ChatMessage < ApplicationRecord
  belongs_to :applicant_chat
  belongs_to :user

  has_many :read_receipts, dependent: :destroy
end
