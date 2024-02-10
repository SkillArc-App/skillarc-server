class ReferenceDropProfileId < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :seeker_references, :seeker_profile_id, :text }
  end
end
