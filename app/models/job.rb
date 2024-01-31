# == Schema Information
#
# Table name: jobs
#
#  id                           :text             not null, primary key
#  benefits_description         :text             not null
#  employment_title             :text             not null
#  employment_type              :enum             not null
#  hide_job                     :boolean          default(FALSE), not null
#  industry                     :text             is an Array
#  location                     :text             not null
#  requirements_description     :text
#  responsibilities_description :text
#  schedule                     :text
#  work_days                    :text
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  employer_id                  :text             not null
#
# Foreign Keys
#
#  Job_employer_id_fkey  (employer_id => employers.id) ON DELETE => restrict ON UPDATE => cascade
#
class Job < ApplicationRecord
  module EmploymentTypes
    ALL = [
      FULLTIME = 'FULLTIME'.freeze,
      PARTTIME = 'PARTTIME'.freeze
    ].freeze
  end

  belongs_to :employer

  has_many :applicants, dependent: :destroy
  has_many :career_paths, dependent: :destroy
  has_many :learned_skills, dependent: :destroy
  has_many :desired_skills, dependent: :destroy
  has_many :desired_certifications, dependent: :destroy
  has_many :job_photos, dependent: :destroy
  has_many :testimonials, dependent: :destroy
  has_many :job_tags, dependent: :destroy
  has_many :tags, through: :job_tags

  scope :shown, -> { where(hide_job: false) }

  validates :employment_title, presence: { in: EmploymentTypes::ALL }

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
