require 'rails_helper'

RSpec.describe BroadcastEventJob do
  it "calls PubSub publish" do
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
      .to receive(:publish)
      .with(message:)
      .and_call_original

    described_class.new.perform(message)
  end
end
