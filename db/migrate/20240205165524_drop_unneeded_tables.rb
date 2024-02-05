class DropUnneededTables < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      drop_table :network_interests
    end
  end
end
