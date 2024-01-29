class ElapseDayJob < ApplicationJob
  queue_as :default

  def perform(now = Time.zone.now)
    EventService.create!(
      aggregate_id: "day",
      event_schema: Events::DayElapsed::V1,
      data: Events::Common::Nothing,
      occurred_at: now
    )
  end
end
