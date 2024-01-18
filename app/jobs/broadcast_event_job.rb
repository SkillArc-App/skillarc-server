class BroadcastEventJob < ApplicationJob
  queue_as :default

  def perform(message)
    Pubsub.publish(event: message)
  end
end
