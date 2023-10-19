RSpec.describe Pubsub do
  it "calls the subscriber when the event is published" do
    # Arrange
    event = "user_created"
    subscriber = double("subscriber")
    allow(subscriber).to receive(:call)
    Pubsub.subscribe(event: event, subscriber: subscriber)

    # Act
    Pubsub.publish(event: event)

    # Assert
    expect(subscriber).to have_received(:call).with(event: event)
  end
end