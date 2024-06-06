class CreateCoachesPersonApplication < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_person_applications, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :coaches_person_context, null: false, type: :uuid
      t.string :employer_name, null: false
      t.string :employment_title, null: false
      t.string :status, null: false
      t.uuid :job_id, null: false
    end
  end
end
