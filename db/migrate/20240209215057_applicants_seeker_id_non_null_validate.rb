class ApplicantsSeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :applicants, name: "applicant_seeker_id_null"
    change_column_null :applicants, :seeker_id, false
    remove_check_constraint :applicants, name: "applicant_seeker_id_null"
  end
end
