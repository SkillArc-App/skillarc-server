class ValidateOtherExperienceFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :other_experiences, :seekers
  end
end
