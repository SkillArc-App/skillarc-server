class AddCertifiedToCoachSeekersContext < ActiveRecord::Migration[7.0]
  def change
    add_column :coach_seeker_contexts, :certified_by, :string
  end
end
