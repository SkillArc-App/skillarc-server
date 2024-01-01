require 'rails_helper'

RSpec.describe CreateEventJob do
  before do
    allow(Pubsub).to receive(:publish)
  end

  it "creates an event" do
    occurred_at = Date.new(2020, 1, 1)

    CreateEventJob.perform(
      aggregate_id: "123",
      event_type: "user_created",
      data: {},
      metadata: {},
      occurred_at:
    )

    # Assert
    expect(Event.count).to eq(1)
    expect(Event.last_created).to have_attributes(
      aggregate_id: "123",
      event_type: "user_created",
      data: {},
      metadata: {},
      occurred_at:
    )
  end

  it "publishes the event" do
    expect(Pubsub).to receive(:publish).with(
      event: instance_of(Event)
    )

    CreateEventJob.perform(
      aggregate_id: "123",
      event_type: "user_created",
      data: {},
      metadata: {},
      occurred_at: Date.new(2020, 1, 1)
    )    
  end
end