# == Schema Information
#
# Table name: coaches_seeker_applications
#
#  id                      :uuid             not null, primary key
#  employment_title        :string           not null
#  status                  :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  application_id          :uuid             not null
#  coach_seeker_context_id :uuid             not null
#
# Indexes
#
#  index_coaches_seeker_applications_on_application_id           (application_id)
#  index_coaches_seeker_applications_on_coach_seeker_context_id  (coach_seeker_context_id)
#
# Foreign Keys
#
#  fk_rails_...  (coach_seeker_context_id => coach_seeker_contexts.id)
#
module Coaches
  class SeekerApplication < ApplicationRecord
    self.table_name = "coaches_seeker_applications"

    belongs_to :coach_seeker_context, class_name: "Coaches::CoachSeekerContext"

    validates :application_id, presence: true
    validates :status, presence: true
    validates :employment_title, presence: true
  end
end
