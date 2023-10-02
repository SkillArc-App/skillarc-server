class Profile < ApplicationRecord
  self.table_name = "Profile"

  belongs_to :user, foreign_key: "userId"
  belongs_to :onboarding_session, foreign_key: "onboardingSessionId"

  def onboarding_session
    OnboardingSession.where(user_id: user_id).first
  end
end