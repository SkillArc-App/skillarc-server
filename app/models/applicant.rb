class Applicant < ApplicationRecord
  belongs_to :job
  belongs_to :profile
  has_many :applicant_statuses

  def status
    applicant_statuses.order(created_at: :desc).first
  end
end
