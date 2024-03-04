class AddEmployerNameToCoachesJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :coaches_jobs, :employer_name, :string
  end
end
