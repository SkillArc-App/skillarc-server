# == Schema Information
#
# Table name: jobs
#
#  id                           :text             not null, primary key
#  employer_id                  :text             not null
#  benefits_description         :text             not null
#  responsibilities_description :text
#  employment_title             :text             not null
#  location                     :text             not null
#  employment_type              :enum             not null
#  hide_job                     :boolean          default(FALSE), not null
#  schedule                     :text
#  work_days                    :text
#  requirements_description     :text
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  industry                     :text             is an Array
#
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
        :applicant_statuses,
        { profile: :user }
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
