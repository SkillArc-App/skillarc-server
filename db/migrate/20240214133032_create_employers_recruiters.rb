class CreateEmployersRecruiters < ActiveRecord::Migration[7.0]
  def change
    create_table :employers_recruiters, id: :uuid do |t|
      t.references :employers_employer, null: false, foreign_key: true, type: :uuid
      t.string :email, null: false

      t.timestamps
    end
  end
end
