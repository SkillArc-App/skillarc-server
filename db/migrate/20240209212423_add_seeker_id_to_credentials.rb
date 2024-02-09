class AddSeekerIdToCredentials < ActiveRecord::Migration[7.0]
  def change
    add_column :credentials, :seeker_id, :uuid
  end
end
