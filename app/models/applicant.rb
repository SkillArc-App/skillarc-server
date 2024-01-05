# == Schema Information
#
# Table name: applicants
#
#  id         :text             not null, primary key
#  job_id     :text             not null
#  profile_id :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Applicant < ApplicationRecord
  belongs_to :job
  belongs_to :profile
  has_many :applicant_statuses

  def status
    applicant_statuses.last_created
  end
end
