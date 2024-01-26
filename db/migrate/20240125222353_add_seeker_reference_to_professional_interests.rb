class AddSeekerReferenceToProfessionalInterests < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :professional_interests, :seeker, null: true, type: :uuid, index: { algorithm: :concurrently }
  end
end
