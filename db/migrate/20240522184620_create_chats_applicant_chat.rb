class CreateChatsApplicantChat < ActiveRecord::Migration[7.1]
  def change
    create_table :chats_applicant_chats do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.uuid :application_id, null: false, index: true
      t.uuid :employer_id, null: false, index: true
      t.uuid :seeker_id, null: false, index: true
      t.string :title, null: false
      t.datetime :chat_created_at, null: false
      t.datetime :chat_updated_at, null: false
    end
  end
end
