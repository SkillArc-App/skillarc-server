require 'rails_helper'

RSpec.describe BroadcastEventJob do
  it "calls PubSub publish" do
    message = Message.new(
      id: SecureRandom.uuid,
      aggregate_id: "123",
      trace_id: SecureRandom.uuid,
      message_type: Events::UserCreated::V1.message_type,
      data: Events::UserCreated::Data::V1.new,
      metadata: Messages::Nothing,
      version: Events::UserCreated::V1.version,
      occurred_at: DateTime.new(2020, 1, 1)
    )

    expect(PUBSUB)
      .to receive(:publish)
      .with(message:)
      .and_call_original

    described_class.new.perform(message)
  end
end
