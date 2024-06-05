class DropCoaches < ActiveRecord::Migration[7.1]
  def change
    drop_table :coaches
  end
end
