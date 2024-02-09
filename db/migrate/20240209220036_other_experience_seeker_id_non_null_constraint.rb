class OtherExperienceSeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :other_experiences, "seeker_id IS NOT NULL", name: "other_experiences_seeker_id_null", validate: false
  end
end
