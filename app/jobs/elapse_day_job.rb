class ElapseDayJob < ApplicationJob
  queue_as :default

  def perform(now = Time.zone.now)
    EventService.create!(
      aggregate_id: "day",
      event_type: Event::EventTypes::DAY_ELAPSED,
      data: {},
      occurred_at: now
    )
  end
end
