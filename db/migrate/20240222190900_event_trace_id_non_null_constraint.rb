class EventTraceIdNonNullConstraint < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :events, "trace_id IS NOT NULL", name: "event_trace_id_null", validate: false
  end
end
