class AddHideJobToCoachesJob < ActiveRecord::Migration[7.1]
  def change
    add_column :coaches_jobs, :hide_job, :boolean, default: false, null: false
  end
end
