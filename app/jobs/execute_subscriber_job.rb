class ExecuteSubscriberJob < ApplicationJob
  queue_as :default

  def perform(message:, subscriber_class_name:)
    PUBSUB.execute_event(message:, subscriber_class_name:)
  end
end
