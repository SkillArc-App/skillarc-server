# == Schema Information
#
# Table name: applicant_analytics
#
#  id                   :uuid             not null, primary key
#  applicant_created_at :datetime
#  applicant_email      :string
#  applicant_name       :string
#  days                 :integer
#  employer_name        :string
#  employment_title     :string
#  hours                :integer
#  status               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  applicant_id         :text             not null
#  employer_id          :text             not null
#  job_id               :text             not null
#
# Indexes
#
#  index_applicant_analytics_on_applicant_id  (applicant_id)
#  index_applicant_analytics_on_employer_id   (employer_id)
#  index_applicant_analytics_on_job_id        (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (applicant_id => applicants.id)
#  fk_rails_...  (employer_id => employers.id)
#  fk_rails_...  (job_id => jobs.id)
#
class ApplicantAnalytic < ApplicationRecord
end
