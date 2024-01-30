RSpec.describe Pubsub do
  it "calls the subscriber when the event is published" do
    # Arrange
    event = build(:events__message, :user_created)

    subscriber = double("subscriber")
    allow(subscriber).to receive(:call)
    subject.subscribe(event_schema: event.event_schema, subscriber:)

    # Act
    subject.publish(event:)

    # Assert
    expect(subscriber).to have_received(:call).with(event:)
  end
end
