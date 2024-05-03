require 'rails_helper'

RSpec.describe Pubsub do
  subject do
    described_class.new(sync:)
  end

  context "when pubsub is sync" do
    let(:sync) { true }

    it "calls the subscriber when the event is published" do
      schema = Events::UserCreated::Data::V1
      schema_string = schema.to_s

      subscriber = DbStreamReactor.build(consumer: Contact::ContactReactor.new, listener_name: SecureRandom.uuid)
      subject.subscribe(message_schema: schema, subscriber:)

      expect(subscriber)
        .to receive(:play)

      subject.publish(schema_string:)
    end
  end

  context "when pubsub is async" do
    let(:sync) { false }

    it "calls enqueues a execute subscriber job" do
      schema = Events::UserCreated::Data::V1
      schema_string = schema.to_s

      subscriber = DbStreamReactor.build(consumer: Contact::ContactReactor.new, listener_name: SecureRandom.uuid)
      allow(subscriber).to receive(:call)

      subject.subscribe(message_schema: schema, subscriber:)

      expect(ExecuteSubscriberJob)
        .to receive(:new)
        .with(
          schema_string:,
          subscriber_id: subscriber.id
        ).and_call_original

      expect(ActiveJob)
        .to receive(:perform_all_later)
        .with([be_a(ExecuteSubscriberJob)])
        .and_call_original

      subject.publish(schema_string:)
    end
  end
end
