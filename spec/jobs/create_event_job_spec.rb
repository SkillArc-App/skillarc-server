require 'rails_helper'

RSpec.describe CreateEventJob do
  it "creates an event" do
    message = EventMessage.new(
      id: SecureRandom.uuid,
      aggregate_id: "123",
      event_type: "user_created",
      data: { cat: 5 },
      metadata: { dog: 3 },
      version: 1,
      occurred_at: Time.zone.local(2020, 1, 1)
    )

    expect(Pubsub)
      .to receive(:publish)
      .with(
        event: message
      )

    described_class.perform_now(message)

    # Assert
    expect(Event.count).to eq(1)

    event = Event.last_created
    expect(event.message).to eq(message)
  end
end
