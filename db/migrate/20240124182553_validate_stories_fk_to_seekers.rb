class ValidateStoriesFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :stories, :seekers
  end
end
