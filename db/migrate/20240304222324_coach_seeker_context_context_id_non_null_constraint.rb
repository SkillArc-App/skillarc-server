class CoachSeekerContextContextIdNonNullConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :coach_seeker_contexts, "context_id IS NOT NULL", name: "context_id_null", validate: false
  end
end
