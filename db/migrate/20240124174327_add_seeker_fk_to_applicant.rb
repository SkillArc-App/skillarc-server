class AddSeekerFkToApplicant < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :applicants, :seekers, validate: false
  end
end
