# == Schema Information
#
# Table name: professional_interests
#
#  id         :text             not null, primary key
#  response   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  seeker_id  :uuid             not null
#
# Indexes
#
#  index_professional_interests_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  fk_rails_...  (seeker_id => seekers.id)
#
class ProfessionalInterest < ApplicationRecord
  belongs_to :seeker
end
