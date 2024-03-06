class CoachSeekerContextKindNonNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :coach_seeker_contexts, "kind IS NOT NULL", name: "coach_seekers_context_kind_null", validate: false
  end
end
