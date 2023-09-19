class Job < ApplicationRecord
  self.table_name = "Job"

  belongs_to :employer, foreign_key: "employerId"
  has_many :career_paths, foreign_key: "jobId"

  scope :shown, -> { where(hideJob: false) }
end