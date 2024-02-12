class BroadcastEventJob < ApplicationJob
  queue_as :default

  def perform(message)
    PUBSUB.publish(message:)
  end
end
