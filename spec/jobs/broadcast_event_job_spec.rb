require 'rails_helper'

RSpec.describe BroadcastEventJob do
  it "calls PubSub publish" do
    message = Events::Message.new(
      id: SecureRandom.uuid,
      aggregate_id: "123",
      event_type: "user_created",
      data: {},
      metadata: {},
      version: 1,
      occurred_at: DateTime.new(2020, 1, 1)
    )

    expect(Pubsub)
      .to receive(:publish)
      .with(event: message)
      .and_call_original

    described_class.new.perform(message)
  end
end
