class CreateCoachPerson < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches_person_contexts, id: :uuid do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :assigned_coach
      t.string :certified_by
      t.string :email
      t.string :phone_number
      t.string :first_name
      t.string :last_name
      t.string :kind, null: false, index: true
      t.datetime :person_captured_at, null: false
      t.datetime :last_active_on
      t.datetime :last_contacted_at
      t.uuid :barriers, array: true, default: []
      t.string :captured_by
      t.string :user_id, index: true
    end
  end
end
