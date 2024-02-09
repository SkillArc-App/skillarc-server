class StorySeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :stories, "seeker_id IS NOT NULL", name: "references_seeker_id_null", validate: false
  end
end
