RSpec.describe Pubsub do
  it "calls the subscriber when the event is published" do
    # Arrange
    event = build(:event_message, :user_created)

    subscriber = double("subscriber")
    allow(subscriber).to receive(:call)
    described_class.subscribe(event: event.event_type, subscriber:)

    # Act
    described_class.publish(event:)

    # Assert
    expect(subscriber).to have_received(:call).with(event:)
  end
end
