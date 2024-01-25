class CreateBarriers < ActiveRecord::Migration[7.0]
  def change
    create_table :barriers, id: :uuid do |t|
      t.string :name, null: false
      t.uuid :barrier_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
