class AddSeekerReferenceToOtherExperience < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :other_experiences, :seeker, null: true, type: :uuid, index: { algorithm: :concurrently }
  end
end
