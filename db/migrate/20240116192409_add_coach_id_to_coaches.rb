class AddCoachIdToCoaches < ActiveRecord::Migration[7.0]
  def change
    add_column :coaches, :coach_id, :uuid
  end
end
