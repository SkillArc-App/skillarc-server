# == Schema Information
#
# Table name: read_receipts
#
#  id              :uuid             not null, primary key
#  read_at         :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chat_message_id :uuid             not null
#  user_id         :text             not null
#
# Indexes
#
#  index_read_receipts_on_chat_message_id  (chat_message_id)
#  index_read_receipts_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_message_id => chat_messages.id)
#  fk_rails_...  (user_id => users.id)
#
class ReadReceipt < ApplicationRecord
  belongs_to :chat_message
  belongs_to :user
end
