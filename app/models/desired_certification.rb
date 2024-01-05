# == Schema Information
#
# Table name: desired_certifications
#
#  id                      :text             not null, primary key
#  master_certification_id :text             not null
#  job_id                  :text             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class DesiredCertification < ApplicationRecord
  belongs_to :master_certification
  belongs_to :job
end
