class ProfileSkillsSeekerIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :profile_skills, name: "profile_skills_seeker_id_null"
    change_column_null :profile_skills, :seeker_id, false
    remove_check_constraint :profile_skills, name: "profile_skills_seeker_id_null"
  end
end
