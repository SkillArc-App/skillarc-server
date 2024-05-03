class CreateCoachesSeekerAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_seeker_attributes, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :coach_seeker_context, foreign_key: true, type: :uuid, null: false
      t.uuid :attribute_id, null: false
      t.string :attribute_name, null: false
      t.string :attribute_value, null: false
    end
  end
end
