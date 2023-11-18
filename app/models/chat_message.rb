class ChatMessage < ApplicationRecord
  belongs_to :applicant_chat
  belongs_to :user
end
