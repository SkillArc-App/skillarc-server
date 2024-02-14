require 'rails_helper'

RSpec.describe Pubsub do
  subject do
    described_class.new(sync:)
  end

  context "when pubsub is sync" do
    let(:sync) { true }

    it "calls the subscriber when the event is published" do
      message = build(:events__message, :user_created, data: Events::UserCreated::Data::V1.new)

      subscriber = Klayvio::JobSaved.new
      allow(subscriber).to receive(:call)
      subject.subscribe(event_schema: message.event_schema, subscriber:)

      expect(subscriber)
        .to receive(:call)
        .with(
          message:
        )

      subject.publish(message:)
    end
  end

  context "when pubsub is async" do
    let(:sync) { false }

    it "calls enqueues a execute subscriber job" do
      message = build(:events__message, :user_created, data: Events::UserCreated::Data::V1.new)

      subscriber = Klayvio::JobSaved.new
      allow(subscriber).to receive(:call)

      subject.subscribe(event_schema: message.event_schema, subscriber:)

      expect(ExecuteSubscriberJob)
        .to receive(:perform_later)
        .with(
          message:,
          subscriber_id: subscriber.id
        ).and_call_original

      subject.publish(message:)
    end
  end
end
