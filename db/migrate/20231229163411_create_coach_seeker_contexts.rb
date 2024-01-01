class CreateCoachSeekerContexts < ActiveRecord::Migration[7.0]
  def change
    create_table :coach_seeker_contexts, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :profile_id

      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number

      t.string :assigned_coach
      t.string :skill_level
      t.string :stage
      t.string :barriers, array: true, default: []
      t.jsonb :notes, default: []
      t.datetime :last_contacted_at

      t.timestamps
    end
  end
end
