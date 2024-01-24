class AddProfileSkillsFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :profile_skills, :seekers, validate: false
  end
end
