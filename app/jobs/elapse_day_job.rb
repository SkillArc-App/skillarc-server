class ElapseDayJob
  def self.perform(now = Time.now)
    Resque.enqueue(
      CreateEventJob,
      aggregate_id: "day",
      event_type: Event::EventTypes::DAY_ELAPSED,
      data: {},
      metadata: {},
      occurred_at: now
    )
  end
end
