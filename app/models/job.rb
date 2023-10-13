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

  def self.with_everything
    includes(
      :employer,
      :learned_skills,
      :desired_skills,
      :desired_certifications,
      :job_photos,
      :testimonials,
      :job_tags,
      :career_paths,
      :applicants
    )
  end
end
