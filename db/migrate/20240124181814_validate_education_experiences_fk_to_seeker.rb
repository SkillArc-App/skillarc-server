class ValidateEducationExperiencesFkToSeeker < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :education_experiences, :seekers
  end
end
