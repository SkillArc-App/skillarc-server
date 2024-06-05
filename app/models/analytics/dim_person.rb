# == Schema Information
#
# Table name: analytics_dim_people
#
#  id                      :bigint           not null, primary key
#  email                   :string
#  first_name              :string
#  kind                    :string           not null
#  last_name               :string
#  lead_created_at         :datetime
#  onboarding_completed_at :datetime
#  phone_number            :string
#  analytics_dim_user_id   :bigint
#  coach_id                :uuid
#  lead_id                 :uuid
#  person_id               :uuid             not null
#  seeker_id               :uuid
#
# Indexes
#
#  index_analytics_dim_people_on_analytics_dim_user_id  (analytics_dim_user_id)
#  index_analytics_dim_people_on_coach_id               (coach_id)
#  index_analytics_dim_people_on_email                  (email)
#  index_analytics_dim_people_on_kind                   (kind)
#  index_analytics_dim_people_on_lead_id                (lead_id)
#  index_analytics_dim_people_on_person_id              (person_id)
#  index_analytics_dim_people_on_phone_number           (phone_number)
#  index_analytics_dim_people_on_seeker_id              (seeker_id)
#
# Foreign Keys
#
#  fk_rails_...  (analytics_dim_user_id => analytics_dim_users.id)
#
module Analytics
  class DimPerson < ApplicationRecord
    self.table_name = "analytics_dim_people"

    module Kind
      ALL = [
        LEAD = 'lead'.freeze,
        USER = 'user'.freeze,
        SEEKER = 'seeker'.freeze,
        COACH = 'coach'.freeze,
        RECRUITER = 'recruiter'.freeze,
        TRAINING_PROVIDER = 'training_provider'.freeze
      ].freeze
    end

    belongs_to :dim_user, class_name: "Analytics::DimUser", foreign_key: "analytics_dim_user_id", optional: true # rubocop:disable Rails/InverseOf

    validates :kind, presence: true, inclusion: { in: Kind::ALL }
    has_many :fact_applications, class_name: "Analytics::FactApplication", foreign_key: "analytics_dim_person_id", inverse_of: :dim_person, dependent: :delete_all

    has_many :fact_people_viewers, class_name: "Analytics::FactPersonViewed", foreign_key: "analytics_dim_person_viewer_id", inverse_of: :dim_person_viewer, dependent: :delete_all
    has_many :fact_people_viewed, class_name: "Analytics::FactPersonViewed", foreign_key: "analytics_dim_person_viewed_id", inverse_of: :dim_person_viewed, dependent: :delete_all

    has_many :fact_coach_executor_actions, class_name: "Analytics::FactCoachAction", foreign_key: "analytics_dim_person_executor_id", inverse_of: :dim_person_executor, dependent: :delete_all
    has_many :fact_coach_target_actions, class_name: "Analytics::FactCoachAction", foreign_key: "analytics_dim_person_target_id", inverse_of: :dim_person_target, dependent: :delete_all
  end
end
