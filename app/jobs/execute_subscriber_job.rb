class ExecuteSubscriberJob < ApplicationJob
  queue_as :default

  def perform(message:, subscriber_id:)
    PUBSUB.execute_event(message:, subscriber_id:)
  end
end
