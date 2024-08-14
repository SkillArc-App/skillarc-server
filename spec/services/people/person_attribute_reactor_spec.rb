require 'rails_helper'

RSpec.describe People::PersonAttributeReactor do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:stream) { People::Streams::Person.new(person_id:) }
  let(:person_id) { SecureRandom.uuid }
  let(:messages) { [] }

  before do
    Event.from_messages!(messages)
  end

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    context "when the message is add person attribute" do
      let(:message) do
        build(
          :message,
          schema: People::Commands::AddPersonAttribute::V1,
          stream:,
          data: {
            id:,
            attribute_values:
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let(:attribute_values) { [] }

      context "when the person stream doesn't exist" do
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end

      context "when the person stream does exist" do
        let(:messages) do
          [
            build(
              :message,
              schema: People::Events::PersonAdded::V1,
              stream:
            )
          ]
        end

        context "when the values are not unique" do
          let(:message_service) { double }
          let(:attribute_values) { %w[cat cat] }

          it "does nothing" do
            subject
          end
        end

        context "when the values are unique" do
          let(:attribute_values) { %w[cat dog] }

          it "emits a person attributed added event" do
            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: People::Events::PersonAttributeAdded::V1,
                trace_id: message.trace_id,
                stream: message.stream,
                data: {
                  id: message.data.id,
                  attribute_id: message.data.attribute_id,
                  attribute_name: message.data.attribute_name,
                  attribute_values: message.data.attribute_values
                }
              )
              .twice
              .and_call_original

            subject
          end
        end
      end
    end

    context "when the message is remove person attribute" do
      let(:message) do
        build(
          :message,
          schema: People::Commands::RemovePersonAttribute::V1,
          stream:,
          data: {
            id:
          }
        )
      end

      let(:id) { SecureRandom.uuid }

      context "when there is not an attribute on the person stream" do
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end

      context "when there is an attribute on the person stream" do
        let(:messages) do
          [
            build(
              :message,
              schema: People::Events::PersonAttributeAdded::V1,
              stream:,
              data: {
                id:
              }
            )
          ]
        end

        it "emits a person attribute remove event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: People::Events::PersonAttributeRemoved::V1,
              trace_id: message.trace_id,
              stream: message.stream,
              data: {
                id: message.data.id
              }
            )
            .twice
            .and_call_original

          subject
        end
      end
    end

    context "when the message is personal interest added" do
      let(:message) do
        build(
          :message,
          schema: People::Events::ProfessionalInterestsAdded::V2,
          stream:,
          data: {
            interests: %w[healthcare construction]
          }
        )
      end

      it "fires off a add person attribute command" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: People::Commands::AddPersonAttribute::V1,
            trace_id: message.trace_id,
            stream: message.stream,
            data: {
              id: be_a(String),
              attribute_id: Attributes::INDUSTRIES_STREAM.attribute_id,
              attribute_name: Attributes::INDUSTRIES_NAME,
              attribute_values: message.data.interests
            }
          )
          .twice
          .and_call_original

        subject
      end
    end
  end
end
