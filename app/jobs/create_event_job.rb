class CreateEventJob
  @queue = :default

  def self.perform(event)
    Event.create!(**event)
  end
end