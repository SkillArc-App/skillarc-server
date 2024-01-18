require 'rails_helper'

RSpec.describe ElapseDayJob do
  it "creates a day elapse event" do
    expect(EventService)
      .to receive(:create!)
      .with(
        aggregate_id: "day",
        event_type: Event::EventTypes::DAY_ELAPSED,
        data: {},
        occurred_at: Date.new(2020, 1, 1)
      )

    described_class.new.perform(Date.new(2020, 1, 1))
  end
end
