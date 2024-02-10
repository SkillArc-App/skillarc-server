# == Schema Information
#
# Table name: applicants
#
#  id         :text             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :text             not null
#  seeker_id  :uuid             not null
#
# Indexes
#
#  index_applicants_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  Applicant_job_id_fkey  (job_id => jobs.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...           (seeker_id => seekers.id)
#
class Applicant < ApplicationRecord
  self.ignored_columns = ["profile_id"]

  belongs_to :job
  belongs_to :seeker

  has_many :applicant_statuses, dependent: :destroy

  def status
    applicant_statuses.last_created
  end
end
