# == Schema Information
#
# Table name: education_experiences
#
#  id                :text             not null, primary key
#  activities        :text
#  gpa               :text
#  graduation_date   :text
#  organization_name :text
#  title             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  organization_id   :text
#  profile_id        :text             not null
#
# Foreign Keys
#
#  EducationExperience_organization_id_fkey  (organization_id => organizations.id) ON DELETE => nullify ON UPDATE => cascade
#  EducationExperience_profile_id_fkey       (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class EducationExperience < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
