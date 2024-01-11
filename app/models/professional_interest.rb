# == Schema Information
#
# Table name: professional_interests
#
#  id         :text             not null, primary key
#  response   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :text             not null
#
# Foreign Keys
#
#  ProfessionalInterests_profile_id_fkey  (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class ProfessionalInterest < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
