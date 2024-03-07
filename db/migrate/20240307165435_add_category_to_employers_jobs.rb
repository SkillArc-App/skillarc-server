class AddCategoryToEmployersJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :employers_jobs, :category, :string, default: 'marketplace'
  end
end
