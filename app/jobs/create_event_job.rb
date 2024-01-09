class CreateEventJob < ApplicationJob
  queue_as :default

  def perform(event)
    e = Event.create!(**event)

    Pubsub.publish(event: e)
  end
end
