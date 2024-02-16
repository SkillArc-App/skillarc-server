# == Schema Information
#
# Table name: applicant_status_reasons
#
#  id                  :uuid             not null, primary key
#  response            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  applicant_status_id :text             not null
#  reason_id           :uuid             not null
#
# Indexes
#
#  index_applicant_status_reasons_on_applicant_status_id  (applicant_status_id)
#  index_applicant_status_reasons_on_reason_id            (reason_id)
#
# Foreign Keys
#
#  fk_rails_...  (applicant_status_id => applicant_statuses.id)
#  fk_rails_...  (reason_id => reasons.id)
#
class ApplicantStatusReason < ApplicationRecord
  belongs_to :applicant_status
  belongs_to :reason
end
