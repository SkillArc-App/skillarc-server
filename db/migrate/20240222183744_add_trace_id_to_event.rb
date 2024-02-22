class AddTraceIdToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :trace_id, :uuid
  end
end
