# == Schema Information
#
# Table name: applicant_statuses
#
#  id           :text             not null, primary key
#  applicant_id :text             not null
#  status       :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ApplicantStatus < ApplicationRecord
  belongs_to :applicant
  has_many :applicant_status_reasons

  module StatusTypes
    ALL = [
      NEW = "new",
      PENDING_INTRO = "pending intro",
      INTRO_MADE = "intro made",
      INTERVIEWING = "interviewing",
      HIRE = "hire",
      PASS = "pass"
    ]
  end

  validates :status, inclusion: { in: StatusTypes::ALL }
end
