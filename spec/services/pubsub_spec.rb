RSpec.describe Pubsub do
  subject do
    described_class.new(sync:)
  end

  context "when pubsub is sync" do
    let(:sync) { true }

    it "calls the subscriber when the event is published" do
      message = build(:events__message, :user_created)

      subscriber = double("subscriber")
      allow(subscriber).to receive(:call)
      subject.subscribe(event_schema: message.event_schema, subscriber:)

      subject.publish(message:)

      expect(subscriber).to have_received(:call).with(message:)
    end
  end

  context "when pubsub is async" do
    let(:sync) { false }

    it "calls enqueues a execute subscriber job" do
      message = build(:events__message, :user_created)

      subscriber = double("subscriber")
      allow(subscriber).to receive(:call)
      subject.subscribe(event_schema: message.event_schema, subscriber:)

      expect(ExecuteSubscriberJob)
        .to receive(:perform_later)
        .with(
          message:,
          subscriber_class_name: "RSpec::Mocks::Double"
        )

      subject.publish(message:)
    end
  end
end
