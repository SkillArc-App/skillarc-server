class AddPersonalExperienceFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :personal_experiences, :seekers, validate: false
  end
end
