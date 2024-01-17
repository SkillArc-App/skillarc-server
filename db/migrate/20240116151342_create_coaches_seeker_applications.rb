class CreateCoachesSeekerApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :coaches_seeker_applications, id: :uuid do |t|
      t.references :coach_seeker_context, foreign_key: true, type: :uuid, null: false
      t.uuid :application_id, null: false
      t.string :employment_title, null: false
      t.string :status, null: false
      t.timestamps
    end

    add_index :coaches_seeker_applications, :application_id
  end
end
