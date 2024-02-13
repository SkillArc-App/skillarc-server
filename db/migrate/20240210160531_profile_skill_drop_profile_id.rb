class ProfileSkillDropProfileId < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :profile_skills, :profile_id, :text }
  end
end
