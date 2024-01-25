# == Schema Information
#
# Table name: seeker_barriers
#
#  id                      :uuid             not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  barrier_id              :uuid             not null
#  coach_seeker_context_id :uuid             not null
#
# Indexes
#
#  index_seeker_barriers_on_barrier_id               (barrier_id)
#  index_seeker_barriers_on_coach_seeker_context_id  (coach_seeker_context_id)
#
# Foreign Keys
#
#  fk_rails_...  (barrier_id => barriers.id)
#  fk_rails_...  (coach_seeker_context_id => coach_seeker_contexts.id)
#

module Coaches
  class SeekerBarrier < ApplicationRecord
    belongs_to :barrier
    belongs_to :coach_seeker_context
  end
end
