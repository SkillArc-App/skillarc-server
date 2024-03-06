class CoachSeekerContextKindNonNullValidate < ActiveRecord::Migration[7.1]
  def change
    validate_check_constraint :coach_seeker_contexts, name: "coach_seekers_context_kind_null"
    change_column_null :coach_seeker_contexts, :kind, false
    remove_check_constraint :coach_seeker_contexts, name: "coach_seekers_context_kind_null"
  end
end
