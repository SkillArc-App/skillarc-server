class AddPersonIdToReminder < ActiveRecord::Migration[7.1]
  def change
    add_column :coaches_reminders, :person_id, :uuid
  end
end
