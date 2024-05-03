class ExecuteSubscriberJob < ApplicationJob
  queue_as :default

  def perform(schema_string:, subscriber_id:)
    PUBSUB.execute_event(schema_string:, subscriber_id:)
  end
end
