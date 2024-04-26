class CreateJobAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :job_attributes, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :job, null: false, foreign_key: true, type: :text
      t.string :acceptible_set, array: true, default: [], null: false

      t.uuid :attribute_id, null: false
      t.string :attribute_name, null: false
    end
  end
end
