class AddSeekerIdToOnboardingSession < ActiveRecord::Migration[7.1]
  def change
    add_column :onboarding_sessions, :seeker_id, :uuid
  end
end
