# == Schema Information
#
# Table name: applicant_analytics
#
#  id                   :uuid             not null, primary key
#  applicant_id         :text             not null
#  job_id               :text             not null
#  employer_id          :text             not null
#  employer_name        :string
#  employment_title     :string
#  applicant_name       :string
#  applicant_email      :string
#  status               :string
#  days                 :integer
#  hours                :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  applicant_created_at :datetime
#
class ApplicantAnalytic < ApplicationRecord
end
