class PersonalExperienceDropProfileId < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :personal_experiences, :profile_id, :text }
  end
end
