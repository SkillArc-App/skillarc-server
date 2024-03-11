class AddUserIdColumnOnSearchSavedJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :search_saved_jobs do |t|
      t.references :search_job, index: true, foreign_key: true, null: false
      t.string :user_id, null: false, index: true

      t.timestamps
    end
  end
end
