class OnboardingSessionRemoveUserId < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :onboarding_sessions, :user_id, :text }
  end
end
