class RemoveUniqueIndexOnSeekerLead < ActiveRecord::Migration[7.0]
  def change
    remove_index :coaches_seeker_leads, name: 'index_coaches_seeker_leads_on_email' # rubocop:disable Rails/ReversibleMigration
  end
end
