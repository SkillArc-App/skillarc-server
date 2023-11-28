class AddUniquenessApplicantChatApplicantIdIndex < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    remove_index :applicant_chats, :applicant_id, algorithm: :concurrently, if_exists: true

    add_index :applicant_chats, :applicant_id, unique: true, algorithm: :concurrently
  end
end
