# == Schema Information
#
# Table name: seeker_notes
#
#  id                      :uuid             not null, primary key
#  note                    :string           not null
#  note_taken_at           :datetime         not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  coach_seeker_context_id :uuid             not null
#  note_id                 :uuid             not null
#
# Indexes
#
#  index_seeker_notes_on_coach_seeker_context_id  (coach_seeker_context_id)
#
# Foreign Keys
#
#  fk_rails_...  (coach_seeker_context_id => coach_seeker_contexts.id)
#
module Coaches
  class SeekerNote < ApplicationRecord
    belongs_to :coach_seeker_context, class_name: "Coaches::CoachSeekerContext"

    validates :note, presence: true
    validates :note_id, presence: true
    validates :note_taken_at, presence: true
  end
end
