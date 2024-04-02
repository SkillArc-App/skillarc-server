class CoachSeekerContextSeekerCapturedAtConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :coach_seeker_contexts, "seeker_captured_at IS NOT NULL", name: "coach_seekers_context_seeker_captured_at_null", validate: false
  end
end
