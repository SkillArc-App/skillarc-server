class DropJobInteractions < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      drop_table :job_interactions
    end
  end
end
