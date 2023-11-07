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

  def self.with_employer_info
    includes(
      :employer,
      applicants: [
        :status,
        profile: :user
      ]
    )
  end

  def self.with_everything
    includes(
      :applicants,
      :career_paths,
      :employer,
      :job_photos,
      :testimonials,
      job_tags: :tag,
      desired_skills: :master_skill,
      learned_skills: :master_skill,
      desired_certifications: :master_certification
    )
  end
end
