class DropSeekerTrainingProviderStatus < ActiveRecord::Migration[7.1]
  def change
    drop_table :seeker_training_provider_program_statuses
  end
end
