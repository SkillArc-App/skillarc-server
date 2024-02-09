class ProfessionalExperienceSeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :personal_experiences, name: "personal_experiences_seeker_id_null"
    change_column_null :personal_experiences, :seeker_id, false
    remove_check_constraint :personal_experiences, name: "personal_experiences_seeker_id_null"
  end
end
