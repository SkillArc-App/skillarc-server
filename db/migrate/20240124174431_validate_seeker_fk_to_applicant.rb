class ValidateSeekerFkToApplicant < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :applicants, :seekers
  end
end
