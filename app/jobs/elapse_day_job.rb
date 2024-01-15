class ElapseDayJob < ApplicationJob
  queue_as :default

  def perform(now = Time.zone.now)
    CreateEventJob.perform_later(
      aggregate_id: "day",
      event_type: Event::EventTypes::DAY_ELAPSED,
      data: {},
      metadata: {},
      occurred_at: now
    )
  end
end
