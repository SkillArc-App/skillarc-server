# == Schema Information
#
# Table name: applicants
#
#  id         :text             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :text             not null
#  profile_id :text             not null
#
# Foreign Keys
#
#  Applicant_job_id_fkey      (job_id => jobs.id) ON DELETE => restrict ON UPDATE => cascade
#  Applicant_profile_id_fkey  (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class Applicant < ApplicationRecord
  belongs_to :job
  belongs_to :profile
  has_many :applicant_statuses

  def status
    applicant_statuses.last_created
  end
end
