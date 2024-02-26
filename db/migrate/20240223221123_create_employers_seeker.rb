class CreateEmployersSeeker < ActiveRecord::Migration[7.0]
  def change
    create_table :employers_seekers, id: :uuid do |t|
      t.uuid :seeker_id, null: false, index: true
      t.string :certified_by

      t.timestamps
    end
  end
end
