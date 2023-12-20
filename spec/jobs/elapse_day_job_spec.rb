require 'rails_helper'

RSpec.describe ElapseDayJob do
  it "creates a day elapse event" do
    expect(Resque).to receive(:enqueue).with(
      CreateEventJob,
      aggregate_id: "day",
      event_type: Event::EventTypes::DAY_ELAPSED,
      data: {},
      metadata: {},
      occurred_at: Date.new(2020, 1, 1)
    )

    described_class.perform(Date.new(2020, 1, 1))
  end
end