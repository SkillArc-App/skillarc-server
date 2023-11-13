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
