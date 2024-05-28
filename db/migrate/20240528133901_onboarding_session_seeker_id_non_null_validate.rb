class OnboardingSessionSeekerIdNonNullValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :onboarding_sessions, name: "onboarding_session_seeker_id_null"
    change_column_null :onboarding_sessions, :seeker_id, false
    remove_check_constraint :onboarding_sessions, name: "onboarding_session_seeker_id_null"
  end
end
