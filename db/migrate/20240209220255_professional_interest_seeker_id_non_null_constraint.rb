class ProfessionalInterestSeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :professional_interests, "seeker_id IS NOT NULL", name: "professional_interest_seeker_id_null", validate: false
  end
end
