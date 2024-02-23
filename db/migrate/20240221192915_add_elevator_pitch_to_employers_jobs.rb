class AddElevatorPitchToEmployersJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :employers_jobs, :elevator_pitch, :text
  end
end
