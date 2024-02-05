class DropPreferences < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      drop_table :preferences
    end
  end
end
