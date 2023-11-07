class Applicant < ApplicationRecord
  belongs_to :job
  belongs_to :profile
  has_many :applicant_statuses

  def status
    applicant_statuses.sort_by(&:created_at).last
  end
end
