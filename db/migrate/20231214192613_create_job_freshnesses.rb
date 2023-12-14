class CreateJobFreshnesses < ActiveRecord::Migration[7.0]
  def change
    create_table :job_freshnesses, id: :uuid do |t|
      t.uuid :job_id
      t.string :status
      t.string :employment_title
      t.string :employer_name

      t.timestamps
    end
  end
end
