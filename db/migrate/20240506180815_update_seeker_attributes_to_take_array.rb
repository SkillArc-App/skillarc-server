class UpdateSeekerAttributesToTakeArray < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :coaches_seeker_attributes do |t| # rubocop:disable Rails/BulkChangeTable
        t.remove :attribute_value # rubocop:disable Rails/ReversibleMigration
        t.string :attribute_values, array: true, default: []
      end
    end
  end
end
