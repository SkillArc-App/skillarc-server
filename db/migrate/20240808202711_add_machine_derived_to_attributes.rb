class AddMachineDerivedToAttributes < ActiveRecord::Migration[7.1]
  def change
    add_column :attributes_attributes, :machine_derived, :boolean, default: false, null: false
  end
end
