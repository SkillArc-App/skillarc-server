class BroadcastEventJob < ApplicationJob
  queue_as :default

  def perform(schema_string)
    PUBSUB.publish(schema_string:)
  end
end
