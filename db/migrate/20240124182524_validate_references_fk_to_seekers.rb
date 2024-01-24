class ValidateReferencesFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :seeker_references, :seekers
  end
end
