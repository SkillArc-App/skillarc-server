class CreateJobOrderSeeker < ActiveRecord::Migration[7.1]
  def change
    create_table :job_orders_seekers, id: :uuid do |t|
      t.string :email
      t.string :phone_number
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
