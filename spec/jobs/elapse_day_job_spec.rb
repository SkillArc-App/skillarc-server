require 'rails_helper'

RSpec.describe ElapseDayJob do
  it "creates a day elapse event" do
    expect(EventService)
      .to receive(:create!)
      .with(
        aggregate_id: "day",
        event_schema: Events::DayElapsed::V1,
        data: Events::Common::Nothing,
        occurred_at: Time.zone.local(2020, 1, 1)
      ).and_call_original

    described_class.new.perform(Time.zone.local(2020, 1, 1))
  end
end
