class AddColumnsToSeekerApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :coaches_seeker_applications, :employer_name, :string
    add_column :coaches_seeker_applications, :job_id, :uuid
  end
end
