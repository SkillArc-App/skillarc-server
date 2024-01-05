# == Schema Information
#
# Table name: education_experiences
#
#  id                :text             not null, primary key
#  organization_id   :text
#  organization_name :text
#  profile_id        :text             not null
#  title             :text
#  activities        :text
#  graduation_date   :text
#  gpa               :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class EducationExperience < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
