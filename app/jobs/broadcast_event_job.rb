class BroadcastEventJob < ApplicationJob
  queue_as :default

  def perform(message)
    PUBSUB.publish(event: message)
  end
end
