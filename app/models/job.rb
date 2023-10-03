class Job < ApplicationRecord
  belongs_to :employer, foreign_key: "employer_id"
  has_many :career_paths, foreign_key: "job_id"
  # has many tags through job tag join table
  has_many :job_tags, foreign_key: "job_id"

  scope :shown, -> { where(hide_job: false) }
end