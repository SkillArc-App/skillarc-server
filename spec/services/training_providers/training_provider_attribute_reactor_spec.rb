require 'rails_helper'

RSpec.describe TrainingProviders::TrainingProviderAttributeReactor do
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:messages) { [] }

  describe "#handle_message" do
    subject do
      instance.handle_message(message)
      instance.handle_message(message)
    end

    before do
      Event.from_messages!(messages)
    end

    context "when the message is training provider created" do
      let(:message) do
        build(
          :message,
          schema: Events::TrainingProviderCreated::V1,
          data: {
            name: "New TP"
          },
          occurred_at: Time.zone.now
        )
      end

      let(:messages) do
        [
          build(
            :message,
            schema: Events::TrainingProviderCreated::V1,
            data: {
              name: "Old TP"
            },
            occurred_at: 5.minutes.ago
          )
        ]
      end

      it "emits a create attribute command" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: Attributes::Commands::Create::V1,
            trace_id: message.trace_id,
            stream: Attributes::TRAINING_PROVIDER_STREAM,
            data: {
              machine_derived: true,
              name: TrainingProviders::TRAINING_PROVIDER_ATTRIBUTE_NAME,
              description: "",
              set: ["Old TP", "New TP"],
              default: []
            },
            metadata: {
              requestor_type: Requestor::Kinds::SERVER,
              requestor_id: nil
            }
          )
          .twice
          .and_call_original

        subject
      end
    end
  end
end
