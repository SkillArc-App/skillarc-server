class RemoveSeekerFkOnReference < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :seeker_references, :seekers
  end
end
