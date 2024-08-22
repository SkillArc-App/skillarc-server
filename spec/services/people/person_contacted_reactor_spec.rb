require 'rails_helper'

RSpec.describe People::PersonContactedReactor do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    before do
      Event.from_messages!(messages)
    end

    context "when the message is contact" do
      let(:message) do
        build(
          :message,
          schema: People::Commands::Contact::V1,
          data: {
            from_person_id:,
            to_person_id:
          }
        )
      end

      let(:from_person_id) { SecureRandom.uuid }
      let(:to_person_id) { SecureRandom.uuid }

      let(:from_person) do
        build(
          :message,
          stream_id: from_person_id,
          schema: People::Events::PersonAdded::V1
        )
      end
      let(:to_person) do
        build(
          :message,
          stream_id: to_person_id,
          schema: People::Events::PersonAdded::V1
        )
      end

      context "when the from person is missing" do
        let(:messages) { [to_person] }

        it "does nothing" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service).not_to receive(:save!)

          subject
        end
      end

      context "when the to person is missing" do
        let(:messages) { [from_person] }

        it "does nothing" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service).not_to receive(:save!)

          subject
        end
      end

      context "when both are present" do
        let(:messages) { [to_person, from_person] }

        it "emits a contacted event" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: People::Events::Contacted::V1,
              trace_id: message.trace_id,
              stream: message.stream,
              data: {
                from_person_id: message.data.from_person_id,
                to_person_id: message.data.to_person_id,
                note: message.data.note,
                contact_type: message.data.contact_type
              }
            )
            .twice
            .and_call_original

          subject
        end
      end
    end
  end
end
