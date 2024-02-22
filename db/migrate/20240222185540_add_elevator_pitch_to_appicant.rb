class AddElevatorPitchToAppicant < ActiveRecord::Migration[7.0]
  def change
    add_column :applicants, :elevator_pitch, :string
  end
end
