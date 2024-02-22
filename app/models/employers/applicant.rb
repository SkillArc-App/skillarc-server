# == Schema Information
#
# Table name: employers_applicants
#
#  id               :uuid             not null, primary key
#  email            :string           not null
#  first_name       :string           not null
#  last_name        :string           not null
#  phone_number     :string
#  status           :string           not null
#  status_as_of     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  applicant_id     :string           not null
#  employers_job_id :uuid             not null
#  seeker_id        :uuid             not null
#
# Indexes
#
#  index_employers_applicants_on_employers_job_id                (employers_job_id)
#  index_employers_applicants_on_seeker_id_and_employers_job_id  (seeker_id,employers_job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (employers_job_id => employers_jobs.id)
#
module Employers
  class Applicant < ApplicationRecord
    belongs_to :job, class_name: "Employers::Job", foreign_key: "employers_job_id", inverse_of: :applicants
    has_many :applicant_status_reasons, class_name: "Employers::ApplicantStatusReason", foreign_key: "employers_applicant_id", inverse_of: :applicant, dependent: :destroy

    module StatusTypes
      ALL = [
        NEW = "new".freeze,
        PENDING_INTRO = "pending intro".freeze,
        INTRO_MADE = "intro made".freeze,
        INTERVIEWING = "interviewing".freeze,
        HIRE = "hire".freeze,
        PASS = "pass".freeze
      ].freeze

      TERMINAL = [HIRE, PASS].freeze
    end

    validates :status, inclusion: { in: StatusTypes::ALL }
    validates :seeker_id, uniqueness: { scope: :employers_job_id }

    scope :active, -> { where.not(status: StatusTypes::TERMINAL) }
  end
end
