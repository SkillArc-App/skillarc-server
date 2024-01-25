class AddReferencesFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :seeker_references, :seekers, validate: false
  end
end
