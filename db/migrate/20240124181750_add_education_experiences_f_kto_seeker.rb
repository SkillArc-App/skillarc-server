class AddEducationExperiencesFKtoSeeker < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :education_experiences, :seekers, validate: false
  end
end
