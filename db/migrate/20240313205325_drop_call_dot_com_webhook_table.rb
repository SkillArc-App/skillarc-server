class DropCallDotComWebhookTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :contact_cal_dot_com_webhooks # rubocop:disable Rails/ReversibleMigration
  end
end
