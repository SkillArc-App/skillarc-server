class ProfessionalInterestSeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :professional_interests, name: "professional_interest_seeker_id_null"
    change_column_null :professional_interests, :seeker_id, false
    remove_check_constraint :professional_interests, name: "professional_interest_seeker_id_null"
  end
end
