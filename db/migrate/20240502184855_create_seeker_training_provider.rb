class CreateSeekerTrainingProvider < ActiveRecord::Migration[7.1]
  def change
    create_table :seeker_training_providers, id: :uuid do |t|
      t.references :training_provider, type: :uuid, null: false
      t.references :program, type: :uuid
      t.references :seeker, type: :uuid, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
