class OtherExperienceSeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :other_experiences, name: "other_experiences_seeker_id_null"
    change_column_null :other_experiences, :seeker_id, false
    remove_check_constraint :other_experiences, name: "other_experiences_seeker_id_null"
  end
end
