class EventTraceIdNonNullValidate < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :events, name: "event_trace_id_null"
    change_column_null :events, :trace_id, false
    remove_check_constraint :events, name: "event_trace_id_null"
  end
end
