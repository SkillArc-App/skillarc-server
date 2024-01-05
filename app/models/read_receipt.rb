# == Schema Information
#
# Table name: read_receipts
#
#  id              :uuid             not null, primary key
#  chat_message_id :uuid             not null
#  user_id         :text             not null
#  read_at         :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ReadReceipt < ApplicationRecord
  belongs_to :chat_message
  belongs_to :user
end
