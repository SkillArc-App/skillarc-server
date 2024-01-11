# == Schema Information
#
# Table name: other_experiences
#
#  id                :text             not null, primary key
#  description       :text
#  end_date          :text
#  is_current        :boolean
#  organization_name :text
#  position          :text
#  start_date        :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  organization_id   :text
#  profile_id        :text             not null
#
# Foreign Keys
#
#  OtherExperience_organization_id_fkey  (organization_id => organizations.id) ON DELETE => nullify ON UPDATE => cascade
#  OtherExperience_profile_id_fkey       (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class OtherExperience < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
