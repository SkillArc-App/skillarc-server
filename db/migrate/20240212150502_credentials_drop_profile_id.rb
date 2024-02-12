class CredentialsDropProfileId < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :credentials, :profile_id, :text }
  end
end
