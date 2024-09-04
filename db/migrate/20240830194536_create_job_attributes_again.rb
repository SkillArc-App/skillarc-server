class CreateJobAttributesAgain < ActiveRecord::Migration[7.1]
  def change
    create_table :job_attributes, id: :uuid do |t|
      t.uuid :attribute_value_ids, null: false, array: true
      t.uuid :attribute_id, null: false
      t.references :job, foreign_key: true, type: :text, null: false
    end
  end
end
