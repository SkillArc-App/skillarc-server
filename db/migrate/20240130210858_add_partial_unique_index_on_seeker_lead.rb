class AddPartialUniqueIndexOnSeekerLead < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :coaches_seeker_leads, :email, unique: true, where: 'email IS NOT NULL', algorithm: :concurrently
  end
end
