RSpec.describe Pubsub do
  it "calls the subscriber when the event is published" do
    # Arrange
    event = build(:event, :user_created)

    subscriber = double("subscriber")
    allow(subscriber).to receive(:call)
    Pubsub.subscribe(event: event.event_type, subscriber:)

    # Act
    Pubsub.publish(event:)

    # Assert
    expect(subscriber).to have_received(:call).with(event:)
  end
end
