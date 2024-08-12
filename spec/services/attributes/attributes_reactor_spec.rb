require 'rails_helper'

RSpec.describe Attributes::AttributesReactor do
  it_behaves_like "a replayable message consumer"

  let(:message_service) { MessageService.new }
  let(:consumer) { described_class.new(message_service:) }
  let(:stream) { Attributes::Streams::Attribute.new(attribute_id:) }
  let(:attribute_id) { SecureRandom.uuid }
  let(:messages) { [] }

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    before do
      Event.from_messages!(messages)
    end

    context "when the message is create" do
      let(:message) do
        build(
          :message,
          stream:,
          schema: Attributes::Commands::Create::V1,
          data: {
            machine_derived: true,
            name: "Attribute",
            description: "Description",
            set:,
            default: []
          }
        )
      end
      let(:set) { %w[cat dog] }

      context "when the set is not unique" do
        let(:set) { %w[cat cat] }

        it "emits a command failed event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Attributes::Events::CommandFailed::V1,
              trace_id: message.trace_id,
              stream: message.stream,
              data: {
                reason: described_class::NON_UNIQUE
              },
              metadata: message.metadata
            )
            .twice
            .and_call_original

          subject
        end
      end

      context "when the set is unique" do
        let(:set) { %w[cat dog] }

        it "emits a created event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Attributes::Events::Created::V3,
              trace_id: message.trace_id,
              stream: message.stream,
              data: {
                **message.data.to_h
              },
              metadata: message.metadata
            )
            .twice
            .and_call_original

          subject
        end
      end
    end

    context "when the message is update" do
      let(:message) do
        build(
          :message,
          stream:,
          schema: Attributes::Commands::Update::V1,
          data: {
            name: "Attribute",
            description: "Description",
            set:,
            default: []
          },
          metadata: {
            requestor_type:
          }
        )
      end
      let(:set) { %w[cat dog] }
      let(:requestor_type) { Requestor::Kinds::USER }

      context "when the set is not unique" do
        let(:set) { %w[cat cat] }

        it "emits a command failed event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Attributes::Events::CommandFailed::V1,
              trace_id: message.trace_id,
              stream: message.stream,
              data: {
                reason: described_class::NON_UNIQUE
              },
              metadata: message.metadata
            )
            .twice
            .and_call_original

          subject
        end
      end

      context "when the attributes are unique" do
        let(:set) { %w[cat dog] }

        context "when there is not an attribute" do
          let(:messages) { [] }

          it "emits a command failed event" do
            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: Attributes::Events::CommandFailed::V1,
                trace_id: message.trace_id,
                stream: message.stream,
                data: {
                  reason: described_class::DOES_NOT_EXIST
                },
                metadata: message.metadata
              )
              .twice
              .and_call_original

            subject
          end
        end

        context "when there is an attribute" do
          let(:messages) do
            [
              build(
                :message,
                schema: Attributes::Events::Created::V3,
                stream:,
                data: {
                  machine_derived:
                }
              )
            ]
          end

          context "when the attribute is machine dervied and not from the server" do
            let(:machine_derived) { true }
            let(:requestor_type) { Requestor::Kinds::USER }

            it "emits a command failed event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  schema: Attributes::Events::CommandFailed::V1,
                  trace_id: message.trace_id,
                  stream: message.stream,
                  data: {
                    reason: described_class::UNAUTHORIZED
                  },
                  metadata: message.metadata
                )
                .twice
                .and_call_original

              subject
            end
          end

          context "when the attribue is not machine derived" do
            let(:machine_derived) { false }

            it "emits a created event" do
              expect(message_service)
                .to receive(:create_once_for_trace!)
                .with(
                  schema: Attributes::Events::Updated::V2,
                  trace_id: message.trace_id,
                  stream: message.stream,
                  data: {
                    **message.data.to_h
                  },
                  metadata: message.metadata
                )
                .twice
                .and_call_original

              subject
            end
          end
        end
      end
    end

    context "when the message is delete" do
      let(:message) do
        build(
          :message,
          stream:,
          schema: Attributes::Commands::Delete::V1,
          metadata: {
            requestor_type:
          }
        )
      end
      let(:set) { %w[cat dog] }
      let(:requestor_type) { Requestor::Kinds::USER }

      context "when there is not an attribute" do
        let(:messages) { [] }

        it "emits a command failed event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Attributes::Events::CommandFailed::V1,
              trace_id: message.trace_id,
              stream: message.stream,
              data: {
                reason: described_class::DOES_NOT_EXIST
              },
              metadata: message.metadata
            )
            .twice
            .and_call_original

          subject
        end
      end

      context "when there is an attribute" do
        let(:messages) do
          [
            build(
              :message,
              schema: Attributes::Events::Created::V3,
              stream:,
              data: {
                machine_derived:
              }
            )
          ]
        end

        context "when the attribute is machine dervied and not from the server" do
          let(:machine_derived) { true }
          let(:requestor_type) { Requestor::Kinds::USER }

          it "emits a command failed event" do
            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: Attributes::Events::CommandFailed::V1,
                trace_id: message.trace_id,
                stream: message.stream,
                data: {
                  reason: described_class::UNAUTHORIZED
                },
                metadata: message.metadata
              )
              .twice
              .and_call_original

            subject
          end
        end

        context "when the attribue is not machine derived" do
          let(:machine_derived) { false }

          it "emits a created event" do
            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: Attributes::Events::Deleted::V2,
                trace_id: message.trace_id,
                stream: message.stream,
                data: Core::Nothing,
                metadata: message.metadata
              )
              .twice
              .and_call_original

            subject
          end
        end
      end
    end
  end
end
