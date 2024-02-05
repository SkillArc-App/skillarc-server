# == Schema Information
#
# Table name: profiles
#
#  id               :text             not null, primary key
#  bio              :text
#  image            :text
#  met_career_coach :boolean          default(FALSE)
#  status           :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :text             not null
#
# Indexes
#
#  Profile_user_id_key  (user_id) UNIQUE
#
# Foreign Keys
#
#  Profile_user_id_fkey  (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
#
class Profile < ApplicationRecord
  belongs_to :user

  has_many :applicants, dependent: :destroy
  has_many :credentials, dependent: :destroy
  has_many :education_experiences, dependent: :destroy
  has_many :other_experiences, dependent: :destroy
  has_many :personal_experiences, dependent: :destroy
  has_many :profile_skills, dependent: :destroy
  has_many :references, inverse_of: :seeker_profile, class_name: "Reference", foreign_key: "seeker_profile_id", dependent: :destroy
  has_many :stories, dependent: :destroy

  def onboarding_session
    OnboardingSession.where(user_id:).first
  end

  def hiring_status
    return 'Interviewing' if applicants.any? { |a| a.status.status == 'interviewing' }

    return 'Applying to Jobs' unless applicants.empty?

    'Profile Complete'
  end
end
