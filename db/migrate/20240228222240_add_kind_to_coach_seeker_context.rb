class AddKindToCoachSeekerContext < ActiveRecord::Migration[7.1]
  def change
    add_column :coach_seeker_contexts, :kind, :string
  end
end
