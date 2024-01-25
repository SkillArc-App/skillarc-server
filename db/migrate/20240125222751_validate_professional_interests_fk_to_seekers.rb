class ValidateProfessionalInterestsFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :professional_interests, :seekers
  end
end
