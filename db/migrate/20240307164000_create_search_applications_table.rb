class CreateSearchApplicationsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :search_applications do |t|
      t.string :status, null: false
      t.uuid :application_id, null: false, index: true
      t.uuid :seeker_id, index: true, null: false
      t.uuid :job_id, null: false

      t.text :elevator_pitch
      t.references :search_job, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
