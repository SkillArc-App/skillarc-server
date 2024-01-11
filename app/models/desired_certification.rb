# == Schema Information
#
# Table name: desired_certifications
#
#  id                      :text             not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  job_id                  :text             not null
#  master_certification_id :text             not null
#
# Foreign Keys
#
#  DesiredCertification_job_id_fkey                   (job_id => jobs.id) ON DELETE => restrict ON UPDATE => cascade
#  DesiredCertification_master_certification_id_fkey  (master_certification_id => master_certifications.id) ON DELETE => restrict ON UPDATE => cascade
#
class DesiredCertification < ApplicationRecord
  belongs_to :master_certification
  belongs_to :job
end
