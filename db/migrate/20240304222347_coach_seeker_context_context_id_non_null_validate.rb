class CoachSeekerContextContextIdNonNullValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :coach_seeker_contexts, name: "context_id_null"
    change_column_null :coach_seeker_contexts, :context_id, false
    remove_check_constraint :coach_seeker_contexts, name: "context_id_null"
  end
end
