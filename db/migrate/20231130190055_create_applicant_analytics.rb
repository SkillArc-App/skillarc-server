class CreateApplicantAnalytics < ActiveRecord::Migration[7.0]
  def change
    create_table :applicant_analytics, id: :uuid do |t|
      t.references :applicant, null: false, foreign_key: true, type: :text
      t.references :job, null: false, foreign_key: true, type: :text
      t.references :employer, null: false, foreign_key: true, type: :text

      t.string :employer_name
      t.string :employment_title
      t.string :applicant_name
      t.string :applicant_email

      t.string :status
      t.integer :days
      t.integer :hours

      t.timestamps
    end
  end
end
