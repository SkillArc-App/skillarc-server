class CoachSeekerContextSeekerCapturedAtValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :coach_seeker_contexts, name: "coach_seekers_context_seeker_captured_at_null"
    change_column_null :coach_seeker_contexts, :seeker_captured_at, false
    remove_check_constraint :coach_seeker_contexts, name: "coach_seekers_context_seeker_captured_at_null"
  end
end
