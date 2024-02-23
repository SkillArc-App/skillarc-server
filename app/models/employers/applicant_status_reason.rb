# == Schema Information
#
# Table name: employers_applicant_status_reasons
#
#  id                     :uuid             not null, primary key
#  reason                 :string           not null
#  response               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  employers_applicant_id :uuid             not null
#
# Indexes
#
#  index_emp_applicant_status_reasons_on_emp_applicant_id  (employers_applicant_id)
#
# Foreign Keys
#
#  fk_rails_...  (employers_applicant_id => employers_applicants.id)
#
module Employers
  class ApplicantStatusReason < ApplicationRecord
    belongs_to :applicant, class_name: "Employers::Applicant", foreign_key: "employers_applicant_id", inverse_of: :applicant_status_reasons
  end
end
