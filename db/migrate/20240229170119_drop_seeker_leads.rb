class DropSeekerLeads < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches_seeker_leads # rubocop:disable Rails/ReversibleMigration
  end
end
