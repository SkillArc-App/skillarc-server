class AddLastActiveOnToCoachSeekerContext < ActiveRecord::Migration[7.0]
  def change
    add_column :coach_seeker_contexts, :last_active_on, :datetime
  end
end
