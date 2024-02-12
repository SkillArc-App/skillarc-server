require 'rails_helper'

RSpec.describe ExecuteSubscriberJob do
  it "calls PUBSUB execute_event" do
    message = Events::Message.new(
      id: SecureRandom.uuid,
      aggregate_id: "123",
      event_type: "user_created",
      data: Events::Common::UntypedHashWrapper.build,
      metadata: Events::Common::Nothing,
      version: 1,
      occurred_at: DateTime.new(2020, 1, 1)
    )

    expect(PUBSUB)
      .to receive(:execute_event)
      .with(message:, subscriber_class_name: "a class")
      .and_call_original

    # Not an actual subscriber
    expect do
      described_class.new.perform(message:, subscriber_class_name: "a class")
    end.to raise_error(NoMethodError)
  end
end
