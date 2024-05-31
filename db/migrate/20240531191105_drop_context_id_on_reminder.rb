class DropContextIdOnReminder < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :coaches_reminders, :context_id, :string }
  end
end
