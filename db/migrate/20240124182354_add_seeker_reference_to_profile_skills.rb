class AddSeekerReferenceToProfileSkills < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :profile_skills, :seeker, null: true, type: :uuid, index: { algorithm: :concurrently }
  end
end
