class CreateEventJob
  @queue = :default

  def self.perform(event)
    e = Event.create!(**event)

    Pubsub.publish(event: e)
  end
end
