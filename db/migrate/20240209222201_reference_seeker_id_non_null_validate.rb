class ReferenceSeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :seeker_references, name: "references_seeker_id_null"
    change_column_null :seeker_references, :seeker_id, false
    remove_check_constraint :seeker_references, name: "references_seeker_id_null"
  end
end
