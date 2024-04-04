# == Schema Information
#
# Table name: coach_seeker_contexts
#
#  id                 :uuid             not null, primary key
#  assigned_coach     :string
#  certified_by       :string
#  email              :string
#  first_name         :string
#  kind               :string           not null
#  last_active_on     :datetime
#  last_contacted_at  :datetime
#  last_name          :string
#  lead_captured_by   :string
#  phone_number       :string
#  seeker_captured_at :datetime         not null
#  skill_level        :string
#  stage              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  context_id         :string           not null
#  lead_id            :uuid
#  seeker_id          :uuid
#  user_id            :string
#
# Indexes
#
#  index_coach_seeker_contexts_on_context_id  (context_id) UNIQUE
#
module Coaches
  class CoachSeekerContext < ApplicationRecord
    module Kind
      ALL = [
        SEEKER = "seeker".freeze,
        LEAD = "lead".freeze
      ].freeze
    end

    has_many :seeker_notes, dependent: :destroy, class_name: "Coaches::SeekerNote"
    has_many :seeker_applications, dependent: :destroy, class_name: "Coaches::SeekerApplication"
    has_many :seeker_barriers, dependent: :destroy, class_name: "Coaches::SeekerBarrier"
    has_many :seeker_job_recommendations, dependent: :destroy, class_name: "Coaches::SeekerJobRecommendation"

    validates :kind, allow_nil: true, inclusion: { in: Kind::ALL }
    validates :context_id, presence: true
    validates :seeker_captured_at, presence: true, on: :create

    scope :leads, -> { where(kind: Kind::LEAD) }
    scope :seekers, -> { where(kind: Kind::SEEKER) }
    scope :with_everything, -> { includes(:seeker_notes, :seeker_applications, :seeker_barriers, seeker_job_recommendations: :job) }
  end
end
