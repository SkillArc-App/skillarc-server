class AddTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams_teams, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
