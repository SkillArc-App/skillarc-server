class DropSearchSavedJobs < ActiveRecord::Migration[7.1]
  def change
    safety_assured { drop_table :search_saved_jobs }
  end
end
