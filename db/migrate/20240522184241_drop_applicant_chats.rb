class DropApplicantChats < ActiveRecord::Migration[7.1]
  def change
    drop_table :applicant_chats # rubocop:disable Rails/ReversibleMigration
  end
end
