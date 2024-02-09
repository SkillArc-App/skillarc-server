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
#  seeker_id   :uuid             not null
#
# Indexes
#
#  index_personal_experiences_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  PersonalExperience_profile_id_fkey  (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...                        (seeker_id => seekers.id)
#
class PersonalExperience < ApplicationRecord
  belongs_to :profile
  belongs_to :seeker

  validates :profile_id, presence: true
  validates :seeker, presence: true
end
