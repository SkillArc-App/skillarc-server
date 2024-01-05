# == Schema Information
#
# Table name: personal_experiences
#
#  id          :text             not null, primary key
#  profile_id  :text             not null
#  activity    :text
#  start_date  :text
#  end_date    :text
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PersonalExperience < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
