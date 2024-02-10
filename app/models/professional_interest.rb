# == Schema Information
#
# Table name: professional_interests
#
#  id         :text             not null, primary key
#  response   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :text             not null
#  seeker_id  :uuid             not null
#
# Indexes
#
#  index_professional_interests_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  ProfessionalInterests_profile_id_fkey  (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...                           (seeker_id => seekers.id)
#
class ProfessionalInterest < ApplicationRecord
  belongs_to :profile
  belongs_to :seeker
end
