class AddIndexToCoachSeekerContextContextId < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :coach_seeker_contexts, :context_id, unique: true, algorithm: :concurrently
  end
end
