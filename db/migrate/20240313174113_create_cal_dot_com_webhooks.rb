class CreateCalDotComWebhooks < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_cal_dot_com_webhooks do |t|
      t.string :cal_dot_com_event_type, null: false
      t.datetime :occurred_at, null: false
      t.jsonb :payload, null: false

      t.timestamps
    end
  end
end
