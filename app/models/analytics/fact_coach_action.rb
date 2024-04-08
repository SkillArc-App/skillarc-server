# == Schema Information
#
# Table name: analytics_fact_coach_actions
#
#  id                                :bigint           not null, primary key
#  action                            :string           not null
#  action_taken_at                   :datetime         not null
#  analyitics_dim_person_executor_id :bigint           not null
#  analyitics_dim_person_target_id   :bigint
#
# Indexes
#
#  idx_on_analyitics_dim_person_executor_id_f217adc13b  (analyitics_dim_person_executor_id)
#  idx_on_analyitics_dim_person_target_id_33c67e4abe    (analyitics_dim_person_target_id)
#  index_analytics_fact_coach_actions_on_action         (action)
#
# Foreign Keys
#
#  fk_rails_...  (analyitics_dim_person_executor_id => analytics_dim_people.id)
#  fk_rails_...  (analyitics_dim_person_target_id => analytics_dim_people.id)
#
module Analytics
  class FactCoachAction < ApplicationRecord
    self.table_name = "analytics_fact_coach_actions"

    module Actions
      ALL = [
        JOB_RECOMMENDED = "job_recommended".freeze,
        SEEKER_CERTIFIED = "seeker_certified".freeze,
        NOTE_ADDED = "note_added".freeze,
        NOTE_MODIFIED = "note_modified".freeze,
        NOTE_DELETED = "note_deleted".freeze,
        LEAD_ADDED = "lead_added".freeze
      ].freeze
    end

    validates :action, inclusion: { in: Actions::ALL }
    belongs_to :dim_person_executor, class_name: "Analytics::DimPerson", foreign_key: "analyitics_dim_person_executor_id", inverse_of: :fact_applications
    belongs_to :dim_person_target, optional: true, class_name: "Analytics::DimPerson", foreign_key: "analyitics_dim_person_target_id", inverse_of: :fact_applications
  end
end
