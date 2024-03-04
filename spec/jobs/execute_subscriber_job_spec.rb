require 'rails_helper'

RSpec.describe ExecuteSubscriberJob do
  it "calls PUBSUB execute_event" do
    message = Message.new(
      id: SecureRandom.uuid,
      aggregate: Aggregates::User.new(user_id: "123"),
      trace_id: SecureRandom.uuid,
      schema: Events::UserCreated::V1,
      data: Events::UserCreated::Data::V1.new,
      metadata: Messages::Nothing,
      occurred_at: DateTime.new(2020, 1, 1)
    )

    expect(PUBSUB)
      .to receive(:execute_event)
      .with(message:, subscriber_id: "a class")
      .and_call_original

    # Not an actual subscriber
    expect do
      described_class.new.perform(message:, subscriber_id: "a class")
    end.to raise_error(NoMethodError)
  end
end
