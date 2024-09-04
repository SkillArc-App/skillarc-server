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
          schema: People::Commands::AddPersonAttribute::V2,
          stream:,
          data: {
            id:,
            attribute_value_ids:
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let(:cat) { SecureRandom.uuid }
      let(:dog) { SecureRandom.uuid }
      let(:attribute_value_ids) { [] }

      context "when the person stream doesn't exist" do
        it "does nothing" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service).not_to receive(:save!)

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
          let(:attribute_value_ids) { [cat, cat] }

          it "does nothing" do
            allow(message_service).to receive(:query).and_call_original
            expect(message_service).not_to receive(:save!)

            subject
          end
        end

        context "when the values are unique" do
          let(:attribute_value_ids) { [cat, dog] }

          it "emits a person attributed added event" do
            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: People::Events::PersonAttributeAdded::V2,
                trace_id: message.trace_id,
                stream: message.stream,
                data: {
                  id: message.data.id,
                  attribute_id: message.data.attribute_id,
                  attribute_value_ids:
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
        it "does nothing" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service).not_to receive(:save!)

          subject
        end
      end

      context "when there is an attribute on the person stream" do
        let(:messages) do
          [
            build(
              :message,
              schema: People::Events::PersonAttributeAdded::V2,
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
            interests: %w[construction]
          }
        )
      end
      let(:healthcare_id) { SecureRandom.uuid }
      let(:construction_id) { SecureRandom.uuid }
      let(:messages) do
        [
          build(
            :message,
            schema: Attributes::Events::Created::V4,
            stream_id: Attributes::INDUSTRIES_STREAM.attribute_id,
            data: {
              set: [
                Core::UuidKeyValuePair.new(
                  key: healthcare_id,
                  value: "healthcare"
                ),
                Core::UuidKeyValuePair.new(
                  key: construction_id,
                  value: "construction"
                )
              ]
            }
          )
        ]
      end

      it "fires off a add person attribute command" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: People::Commands::AddPersonAttribute::V2,
            trace_id: message.trace_id,
            stream: message.stream,
            data: {
              id: be_a(String),
              attribute_id: Attributes::INDUSTRIES_STREAM.attribute_id,
              attribute_value_ids: [construction_id]
            }
          )
          .twice
          .and_call_original

        subject
      end
    end

    context "when the message is person training provider added" do
      let(:message) do
        build(
          :message,
          schema: People::Events::PersonTrainingProviderAdded::V1,
          stream:,
          data: {
            training_provider_id:
          }
        )
      end
      let(:training_provider_id) { SecureRandom.uuid }
      let(:attribute_set_id) { SecureRandom.uuid }
      let(:messages) do
        [
          build(
            :message,
            schema: Events::TrainingProviderCreated::V1,
            stream_id: training_provider_id,
            data: {
              name: "A name"
            }
          ),
          build(
            :message,
            schema: Attributes::Events::Created::V4,
            stream_id: Attributes::TRAINING_PROVIDER_STREAM.attribute_id,
            data: {
              set: [
                Core::UuidKeyValuePair.new(
                  key: attribute_set_id,
                  value: "A name"
                )
              ]
            }
          )
        ]
      end

      it "fires off a add person attribute command" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: People::Commands::AddPersonAttribute::V2,
            trace_id: message.trace_id,
            stream: message.stream,
            data: {
              id: be_a(String),
              attribute_id: Attributes::TRAINING_PROVIDER_STREAM.attribute_id,
              attribute_value_ids: [attribute_set_id]
            }
          )
          .twice
          .and_call_original

        subject
      end
    end
  end
end
