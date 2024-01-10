# == Schema Information
#
# Table name: seeker_notes
#
#  id                      :uuid             not null, primary key
#  coach_seeker_context_id :uuid             not null
#  note_id                 :uuid             not null
#  note                    :string           not null
#  note_taken_at           :datetime         not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class SeekerNote < ApplicationRecord
  belongs_to :coach_seeker_context

  validates :note, presence: true
  validates :note_id, presence: true
  validates :note_taken_at, presence: true
end
