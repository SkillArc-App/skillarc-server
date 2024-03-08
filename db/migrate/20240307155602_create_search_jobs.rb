class CreateSearchJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :search_jobs do |t|
      t.uuid :job_id, null: false
      t.boolean :hidden, null: false, default: false
      t.string :employment_title, null: false
      t.string :industries, array: true, default: []
      t.string :category, null: false
      t.text :location, null: false
      t.string :employment_type, null: false
      t.integer :starting_upper_pay
      t.integer :starting_lower_pay
      t.string :tags, array: true, default: []
      t.uuid :employer_id, null: false
      t.string :employer_name, null: false
      t.text :employer_logo_url

      t.timestamps
    end

    add_index :search_jobs, :tags
    add_index :search_jobs, :job_id, unique: true
    add_index :search_jobs, :location
    add_index :search_jobs, :industries
    add_index :search_jobs, :employment_title
    add_index :search_jobs, :employment_type
    add_index :search_jobs, :employer_name
  end
end
