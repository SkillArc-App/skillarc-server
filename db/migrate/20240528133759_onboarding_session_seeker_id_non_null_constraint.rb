class OnboardingSessionSeekerIdNonNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :onboarding_sessions, "seeker_id IS NOT NULL", name: "onboarding_session_seeker_id_null", validate: false
  end
end
