# == Schema Information
#
# Table name: professional_interests
#
#  id         :text             not null, primary key
#  profile_id :text             not null
#  response   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProfessionalInterest < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
