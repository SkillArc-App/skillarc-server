require 'rails_helper'

RSpec.describe ElapseDayJob do
  it "creates a day elapse event" do
    expect(EventService)
      .to receive(:create!)
      .with(
        day: "day",
        event_schema: Events::DayElapsed::V1,
        data: Events::DayElapsed::Data::V1.new(
          date: Date.new(2020, 1, 1),
          day_of_week: Events::DayElapsed::Data::DaysOfWeek::WEDNESDAY
        ),
        occurred_at: Time.zone.local(2020, 1, 1)
      ).and_call_original

    described_class.new.perform(Time.zone.local(2020, 1, 1))
  end
end
