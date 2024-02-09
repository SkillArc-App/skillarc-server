class ApplicantsSeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :applicants, "seeker_id IS NOT NULL", name: "applicant_seeker_id_null", validate: false
  end
end
