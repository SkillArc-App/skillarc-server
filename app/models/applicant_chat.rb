class ApplicantChat < ApplicationRecord
  belongs_to :applicant

  has_many :messages, class_name: 'ChatMessage', dependent: :destroy

  validates :applicant, presence: true, uniqueness: true
end
