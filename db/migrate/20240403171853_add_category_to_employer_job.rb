class AddCategoryToEmployerJob < ActiveRecord::Migration[7.1]
  def change
    add_column :employers_jobs, :category, :string, null: false, default: Job::Categories::MARKETPLACE
  end
end
