# == Schema Information
#
# Table name: coaches_seeker_job_recommendations
#
#  id                      :uuid             not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  coach_id                :uuid             not null
#  coach_seeker_context_id :uuid             not null
#  job_id                  :uuid             not null
#
# Indexes
#
#  index_coaches_seeker_job_recommendations_on_coach_id         (coach_id)
#  index_coaches_seeker_job_recommendations_on_job_id           (job_id)
#  index_seeker_job_recommendations_on_coach_seeker_context_id  (coach_seeker_context_id)
#
# Foreign Keys
#
#  fk_rails_...  (coach_id => coaches.id)
#  fk_rails_...  (coach_seeker_context_id => coach_seeker_contexts.id)
#  fk_rails_...  (job_id => coaches_jobs.id)
#
module Coaches
  class SeekerJobRecommendation < ApplicationRecord
    self.table_name = "coaches_seeker_job_recommendations"

    belongs_to :coach_seeker_context, class_name: "Coaches::CoachSeekerContext"
    belongs_to :job, class_name: "Coaches::Job"

    belongs_to :coach, class_name: "Coaches::Coach"
  end
end
