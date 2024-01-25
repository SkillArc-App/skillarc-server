class AddProfessionalInterestsFkToSeekers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :professional_interests, :seekers, validate: false
  end
end
