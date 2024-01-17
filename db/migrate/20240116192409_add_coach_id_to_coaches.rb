class AddCoachIdToCoaches < ActiveRecord::Migration[7.0]
  def change
    add_column :coaches, :coach_id, :uuid, null: false
  end
end
