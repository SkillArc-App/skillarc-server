require 'rails_helper'

RSpec.describe ExecuteSubscriberJob do
  it "calls PUBSUB execute_event" do
    schema_string = "Some string"

    expect(PUBSUB)
      .to receive(:execute_event)
      .with(schema_string:, subscriber_id: "a class")
      .and_call_original

    # Not an actual subscriber
    expect do
      described_class.new.perform(schema_string:, subscriber_id: "a class")
    end.to raise_error(NoMethodError)
  end
end
