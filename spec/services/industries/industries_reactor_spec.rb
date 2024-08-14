require 'rails_helper'

RSpec.describe Industries::IndustriesReactor do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:stream) { Industries::INDUSTRIES_STREAM }
  let(:messages) { [] }

  before do
    Event.from_messages!(messages)
  end

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    context "when the message set industries" do
      let(:message) do
        build(
          :message,
          stream:,
          schema: Industries::Commands::SetIndustries::V1,
          data: {
            industries: %w[cats dogs]
          }
        )
      end

      it "emit a added event" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            stream: message.stream,
            trace_id: message.trace_id,
            schema: Industries::Events::IndustriesSet::V1,
            data: {
              industries: message.data.industries
            }
          )
          .twice
          .and_call_original

        subject
      end
    end

    context "when the message is industries set" do
      let(:message) do
        build(
          :message,
          stream:,
          schema: Industries::Events::IndustriesSet::V1,
          data: {
            industries: %w[cats dogs]
          }
        )
      end

      it "emit a create command" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: Attributes::Commands::Create::V1,
            trace_id: message.trace_id,
            stream: Attributes::INDUSTRIES_STREAM,
            data: {
              machine_derived: true,
              name: Industries::INDUSTRIES_NAME,
              description: "",
              set: message.data.industries,
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
