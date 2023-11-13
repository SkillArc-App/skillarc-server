class ApplicantStatusReason < ApplicationRecord
  belongs_to :applicant_status
  belongs_to :reason
end
