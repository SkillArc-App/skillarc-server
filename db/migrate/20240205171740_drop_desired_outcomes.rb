class DropDesiredOutcomes < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      drop_table :desired_outcomes
    end
  end
end
