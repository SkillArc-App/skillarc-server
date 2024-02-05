class DropSkills < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      drop_table :skills
    end
  end
end
