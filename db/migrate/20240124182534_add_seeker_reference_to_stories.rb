class AddSeekerReferenceToStories < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :stories, :seeker, null: true, type: :uuid, index: { algorithm: :concurrently }
  end
end
