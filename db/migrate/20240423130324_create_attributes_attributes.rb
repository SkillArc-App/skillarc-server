class CreateAttributesAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :attributes_attributes, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :name
      t.text :description

      t.string :set, array: true, null: false
      t.string :default, array: true, null: false
    end
  end
end
