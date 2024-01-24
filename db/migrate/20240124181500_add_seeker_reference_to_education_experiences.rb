class AddSeekerReferenceToEducationExperiences < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :education_experiences, :seeker, null: true, type: :uuid, index: { algorithm: :concurrently }
  end
end
