class AddJobCategoryToJob < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :category, :string, default: 'marketplace'
  end
end
