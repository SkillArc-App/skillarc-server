class CreateJobOrderJob < ActiveRecord::Migration[7.1]
  def change
    create_table :job_orders_jobs, id: :uuid do |t|
      t.string :employment_title, null: false
      t.string :employer_name, null: false
      t.uuid :employer_id, null: false, index: true

      t.timestamps
    end
  end
end
