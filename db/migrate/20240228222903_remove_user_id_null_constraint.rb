class RemoveUserIdNullConstraint < ActiveRecord::Migration[7.1]
  def change
    change_column_null :coach_seeker_contexts, :user_id, true
  end
end
