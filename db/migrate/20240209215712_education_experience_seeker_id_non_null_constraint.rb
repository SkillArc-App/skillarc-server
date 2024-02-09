class EducationExperienceSeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :education_experiences, "seeker_id IS NOT NULL", name: "education_experiences_seeker_id_null", validate: false
  end
end
