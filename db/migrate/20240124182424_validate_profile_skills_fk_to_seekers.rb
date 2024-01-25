class ValidateProfileSkillsFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :profile_skills, :seekers
  end
end
