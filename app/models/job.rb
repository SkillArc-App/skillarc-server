class Job < ApplicationRecord
  belongs_to :employer

  has_many :applicants
  has_many :career_paths
  has_many :learned_skills
  has_many :desired_skills
  has_many :desired_certifications
  has_many :job_photos
  has_many :testimonials
  has_many :job_tags

  scope :shown, -> { where(hide_job: false) }
end
