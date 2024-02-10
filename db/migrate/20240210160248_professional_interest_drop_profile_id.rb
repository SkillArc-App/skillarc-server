class ProfessionalInterestDropProfileId < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :professional_interests, :profile_id, :text }
  end
end
