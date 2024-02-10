class ApplicantDropProfileId < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :applicants, :profile_id, :text }
  end
end
