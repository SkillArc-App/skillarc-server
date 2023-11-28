class ChatMessage < ApplicationRecord
  belongs_to :applicant_chat
  belongs_to :user

  has_many :read_receipts
end
