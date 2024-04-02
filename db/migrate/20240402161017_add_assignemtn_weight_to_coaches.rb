class AddAssignemtnWeightToCoaches < ActiveRecord::Migration[7.1]
  def change
    add_column :coaches, :assignment_weight, :float, null: false, default: 1
  end
end
