class DropSeekerTrainingProvider < ActiveRecord::Migration[7.1]
  def change
    drop_table :seeker_training_providers # rubocop:disable Rails/ReversibleMigration
  end
end
