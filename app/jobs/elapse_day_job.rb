class ElapseDayJob < ApplicationJob
  queue_as :default

  def perform(now = Time.zone.now)
    EventService.create!(
      day: "day",
      event_schema: Events::DayElapsed::V1,
      data: Events::DayElapsed::Data::V1.new(
        date: now.to_date,
        day_of_week: now.strftime("%A").downcase
      ),
      occurred_at: now
    )
  end
end
