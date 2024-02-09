class EducationExperienceSeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :education_experiences, name: "education_experiences_seeker_id_null"
    change_column_null :education_experiences, :seeker_id, false
    remove_check_constraint :education_experiences, name: "education_experiences_seeker_id_null"
  end
end
