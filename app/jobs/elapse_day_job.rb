class ElapseDayJob < ApplicationJob
  queue_as :default

  include EventEmitter

  def perform(now = Time.zone.now)
    with_event_service do
      event_service.create!(
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
end
