class CreateInfrastructureTask < ActiveRecord::Migration[7.1]
  def change
    create_table :infrastructure_tasks, id: :uuid do |t|
      t.datetime :execute_at, null: false, index: true
      t.string :state, null: false, index: true
      t.jsonb :command, null: false
      t.timestamps
    end
  end
end
