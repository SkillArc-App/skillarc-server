# == Schema Information
#
# Table name: personal_experiences
#
#  id          :text             not null, primary key
#  activity    :text
#  description :text
#  end_date    :text
#  start_date  :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  profile_id  :text             not null
#
# Foreign Keys
#
#  PersonalExperience_profile_id_fkey  (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class PersonalExperience < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
