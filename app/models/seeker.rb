# == Schema Information
#
# Table name: seekers
#
#  id         :uuid             not null, primary key
#  bio        :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :text             not null
#
# Indexes
#
#  index_seekers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Seeker < ApplicationRecord
  belongs_to :user

  has_many :applicants, dependent: :destroy
  has_many :education_experiences, dependent: :destroy
  has_many :other_experiences, dependent: :destroy
  has_many :personal_experiences, dependent: :destroy
  has_many :profile_skills, dependent: :destroy
  has_many :references, class_name: "Reference", dependent: :destroy
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
