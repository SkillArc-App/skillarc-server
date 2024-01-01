class ChangeCoachSeekerContextUserId < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      change_column :coach_seeker_contexts, :user_id, :string
    end
  end
end
