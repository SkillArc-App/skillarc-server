class DropCurrentStepFromOnboardingSession < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :onboarding_sessions, :current_step, :text }
  end
end
