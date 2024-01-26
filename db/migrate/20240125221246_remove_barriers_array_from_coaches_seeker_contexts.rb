class RemoveBarriersArrayFromCoachesSeekerContexts < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      remove_column :coach_seeker_contexts, :barriers, :string, array: true, default: []
    end
  end
end
