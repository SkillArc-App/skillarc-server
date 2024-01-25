class AddOtherExperienceFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :other_experiences, :seekers, validate: false
  end
end
