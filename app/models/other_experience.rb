# == Schema Information
#
# Table name: other_experiences
#
#  id                :text             not null, primary key
#  organization_id   :text
#  organization_name :text
#  profile_id        :text             not null
#  start_date        :text
#  is_current        :boolean
#  end_date          :text
#  description       :text
#  position          :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class OtherExperience < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
