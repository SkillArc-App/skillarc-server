# == Schema Information
#
# Table name: coaches_seeker_attributes
#
#  id                      :uuid             not null, primary key
#  attribute_name          :string           not null
#  attribute_values        :string           default([]), is an Array
#  attribute_id            :uuid             not null
#  coach_seeker_context_id :uuid             not null
#
# Indexes
#
#  index_coaches_seeker_attributes_on_coach_seeker_context_id  (coach_seeker_context_id)
#
# Foreign Keys
#
#  fk_rails_...  (coach_seeker_context_id => coach_seeker_contexts.id)
#
module Coaches
  class SeekerAttribute < ApplicationRecord
    self.table_name = "coaches_seeker_attributes"

    belongs_to :coach_seeker_context, class_name: "Coaches::CoachSeekerContext"
  end
end
