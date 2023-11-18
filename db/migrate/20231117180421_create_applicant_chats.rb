class CreateApplicantChats < ActiveRecord::Migration[7.0]
  def change
    create_table :applicant_chats, id: :uuid do |t|
      t.references :applicant, null: false, foreign_key: true, type: :text

      t.timestamps
    end
  end
end
