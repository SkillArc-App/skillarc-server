class CreateSeekerBarriers < ActiveRecord::Migration[7.0]
  def change
    create_table :seeker_barriers, id: :uuid do |t|
      t.references :coach_seeker_context, foreign_key: true, type: :uuid, null: false
      t.references :barrier, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end
  end
end
