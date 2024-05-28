class OnboardingSessionAddSeekerIdIndex < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :onboarding_sessions, :seeker_id, unique: true, algorithm: :concurrently
  end
end
