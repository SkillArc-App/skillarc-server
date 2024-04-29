class DropUserOnboardingSessionColumn < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :users, :onboarding_session_id, :text }
    safety_assured { remove_column :users, :user_type, :text }
  end
end
