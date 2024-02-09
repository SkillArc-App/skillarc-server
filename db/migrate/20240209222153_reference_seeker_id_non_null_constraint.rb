class ReferenceSeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :seeker_references, "seeker_id IS NOT NULL", name: "references_seeker_id_null", validate: false
  end
end
