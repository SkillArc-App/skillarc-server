class AddChatEnabledToEmployers < ActiveRecord::Migration[7.0]
  def change
    add_column :employers, :chat_enabled, :boolean, default: false, null: false
  end
end
