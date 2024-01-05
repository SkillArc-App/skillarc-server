# == Schema Information
#
# Table name: applicant_chats
#
#  id           :uuid             not null, primary key
#  applicant_id :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ApplicantChat < ApplicationRecord
  belongs_to :applicant

  has_many :messages, class_name: 'ChatMessage', dependent: :destroy

  validates :applicant, presence: true, uniqueness: true
end
