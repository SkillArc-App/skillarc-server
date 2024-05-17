class CreateJobOrderNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :job_orders_notes, id: :uuid do |t|
      t.references :job_orders_job_orders, null: false, type: :uuid
      t.datetime :note_taken_at, null: false
      t.string :note_taken_by, null: false
      t.string :note, null: false

      t.timestamps
    end
  end
end
