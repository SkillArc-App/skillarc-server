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
#  seeker_id         :uuid
#
# Indexes
#
#  index_education_experiences_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  EducationExperience_organization_id_fkey  (organization_id => organizations.id) ON DELETE => nullify ON UPDATE => cascade
#  EducationExperience_profile_id_fkey       (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...                              (seeker_id => seekers.id)
#
class EducationExperience < ApplicationRecord
  belongs_to :profile
  belongs_to :seeker, optional: true

  validates :profile_id, presence: true
  validates :seeker, presence: true, on: :create
end
