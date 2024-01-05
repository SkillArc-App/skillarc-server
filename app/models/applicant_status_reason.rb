# == Schema Information
#
# Table name: applicant_status_reasons
#
#  id                  :uuid             not null, primary key
#  applicant_status_id :text             not null
#  reason_id           :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class ApplicantStatusReason < ApplicationRecord
  belongs_to :applicant_status
  belongs_to :reason
end
