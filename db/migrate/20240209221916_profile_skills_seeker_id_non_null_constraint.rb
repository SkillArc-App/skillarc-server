class ProfileSkillsSeekerIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :profile_skills, "seeker_id IS NOT NULL", name: "profile_skills_seeker_id_null", validate: false
  end
end
