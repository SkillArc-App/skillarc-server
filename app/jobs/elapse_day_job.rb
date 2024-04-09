class ElapseDayJob < ApplicationJob
  queue_as :default

  include MessageEmitter

  def perform(now = Time.zone.now)
    with_message_service do
      message_service.create!(
        day: "day",
        schema: Events::DayElapsed::V1,
        data: {
          date: now.to_date,
          day_of_week: now.strftime("%A").downcase
        },
        occurred_at: now
      )
    end
  end
end
