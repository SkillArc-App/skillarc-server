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
#  seeker_id         :uuid             not null
#
# Indexes
#
#  index_other_experiences_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  OtherExperience_organization_id_fkey  (organization_id => organizations.id) ON DELETE => nullify ON UPDATE => cascade
#  OtherExperience_profile_id_fkey       (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...                          (seeker_id => seekers.id)
#
class OtherExperience < ApplicationRecord
  belongs_to :profile
  belongs_to :seeker

  validates :profile_id, presence: true
  validates :seeker, presence: true
end
