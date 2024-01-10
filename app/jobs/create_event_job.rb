class CreateEventJob < ApplicationJob
  queue_as :default

  def perform(message)
    Event.from_message!(message)

    Pubsub.publish(event: message)
  end
end
