class AddSeekerReferenceToReferences < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :seeker_references, :seeker, null: true, type: :uuid, index: { algorithm: :concurrently }
  end
end
