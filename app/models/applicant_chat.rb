# == Schema Information
#
# Table name: applicant_chats
#
#  id           :uuid             not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  applicant_id :text             not null
#
# Indexes
#
#  index_applicant_chats_on_applicant_id  (applicant_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (applicant_id => applicants.id)
#
class ApplicantChat < ApplicationRecord
  belongs_to :applicant

  has_many :messages, class_name: 'ChatMessage', dependent: :destroy

  validates :applicant, uniqueness: true
end
