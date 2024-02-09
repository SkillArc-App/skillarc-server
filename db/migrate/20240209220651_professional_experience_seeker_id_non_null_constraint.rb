class ProfessionalExperienceSeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :personal_experiences, "seeker_id IS NOT NULL", name: "personal_experiences_seeker_id_null", validate: false
  end
end
