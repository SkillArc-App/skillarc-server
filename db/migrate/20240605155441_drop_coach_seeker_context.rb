class DropCoachSeekerContext < ActiveRecord::Migration[7.1]
  def change
    drop_table :coach_seeker_contexts # rubocop:disable Rails/ReversibleMigration
  end
end
