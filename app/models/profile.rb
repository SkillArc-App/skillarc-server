# == Schema Information
#
# Table name: profiles
#
#  id               :text             not null, primary key
#  user_id          :text             not null
#  bio              :text
#  image            :text
#  status           :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  met_career_coach :boolean          default(FALSE)
#
class Profile < ApplicationRecord
  belongs_to :user

  has_many :applicants
  has_many :education_experiences
  has_many :other_experiences
  has_many :personal_experiences
  has_many :profile_skills
  has_many :references, class_name: "Reference", foreign_key: "seeker_profile_id"
  has_many :stories

  def onboarding_session
    OnboardingSession.where(user_id:).first
  end

  def hiring_status
    return 'Interviewing' if applicants.any? { |a| a.status.status == 'interviewing' }

    return 'Applying to Jobs' unless applicants.empty?

    'Profile Complete'
  end
end
