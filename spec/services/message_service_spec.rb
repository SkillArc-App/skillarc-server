require 'rails_helper'

RSpec.describe MessageService do
  describe ".create!" do
    subject do
      described_class.create!(
        id:,
        message_schema:,
        aggregate_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:message_type) { Messages::Types::CHAT_CREATED }
    let(:aggregate_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Messages::UntypedHashWrapper.new(data: "cool") }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Messages::UntypedHashWrapper.new(metadata: "cooler") }
    let(:version) { 4 }
    let(:id) { SecureRandom.uuid }

    context "when the event_schema is not a Messages::Schema" do
      let(:message_schema) { 10 }

      it "raises a NotEventSchemaError" do
        expect { subject }.to raise_error(described_class::NotEventSchemaError)
      end
    end

    context "when event_schema is a Messages::Schema" do
      let!(:message_schema) do
        Messages::Schema.build(
          data: Messages::UntypedHashWrapper,
          metadata: Messages::UntypedHashWrapper,
          message_type:,
          version:
        )
      end

      context "when data doesn't type check" do
        let(:data) { "cat" }
        let(:version) { 1 }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(Message::InvalidSchemaError)
        end
      end

      context "when metadata doesn't type check" do
        let(:metadata) { [1, 2, 3] }
        let(:version) { 2 }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(Message::InvalidSchemaError)
        end
      end

      context "when data and metadata type check" do
        let(:version) { 3 }

        it "enqueues a BroadcastEvent job, persists and event and returns the produced event message" do
          expect(BroadcastEventJob)
            .to receive(:perform_later)
            .with(
              Message.new(
                id:,
                trace_id:,
                aggregate_id:,
                data:,
                occurred_at:,
                metadata:,
                schema: message_schema
              )
            )

          expect { subject }.to change(Event, :count).by(1)
          expect(subject.id).to eq(Event.last_created.message.id)
          expect(subject.aggregate_id).to eq(Event.last_created.message.aggregate_id)
          expect(subject.schema).to eq(Event.last_created.message.schema)
          expect(subject.data).to eq(Event.last_created.message.data)
          expect(subject.metadata).to eq(Event.last_created.message.metadata)
          expect(subject.occurred_at).to eq(Event.last_created.message.occurred_at)
        end
      end
    end
  end

  describe ".register" do
    subject do
      described_class.register(message_schema:)
    end

    context "passed something other than a Event::Schema" do
      let(:message_schema) { { not: "a schema" } }

      it "raises a NotSchemaError" do
        expect { subject }.to raise_error(described_class::NotSchemaError)
      end
    end

    context "when passed an Event::Schema" do
      # Can't directly test see the Messages::Schema spec
    end
  end

  describe ".all_schemas" do
    subject { described_class.all_schemas }

    let!(:schema) do
      Messages::Schema.build(
        data: Array,
        metadata: Array,
        message_type: Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST,
        version: 1
      )
    end

    it "returns all registered schemas" do
      expect(subject).to include(schema)
    end
  end

  describe ".get_schema" do
    subject do
      described_class.get_schema(message_type:, version:)
    end

    context "when the schema does not exist" do
      let(:message_type) { "not_a_real_event" }
      let(:version) { 1 }

      it "raises a SchemaNotFoundError" do
        expect { subject }.to raise_error(described_class::SchemaNotFoundError)
      end
    end

    context "when the schema exists" do
      let!(:schema) do
        Messages::Schema.build(
          data: Array,
          metadata: Array,
          message_type:,
          version:
        )
      end
      let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
      let(:version) { 1 }

      it "returns the schema" do
        expect(subject).to eq(schema)
      end
    end
  end

  describe ".migrate_event" do
    let(:message_schema) { Events::UserCreated::V1 }

    let!(:message1) do
      Message.new(
        id: SecureRandom.uuid,
        aggregate_id: SecureRandom.uuid,
        trace_id: SecureRandom.uuid,
        schema: message_schema,
        occurred_at: Time.zone.parse('2000-1-1'),
        data: Events::UserCreated::Data::V1.new(first_name: "John"),
        metadata: Messages::Nothing
      )
    end
    let!(:message2) do
      Message.new(
        id: SecureRandom.uuid,
        aggregate_id: SecureRandom.uuid,
        trace_id: SecureRandom.uuid,
        schema: message_schema,
        occurred_at: Time.zone.parse('2000-1-1'),
        data: Events::UserCreated::Data::V1.new(first_name: "Chris"),
        metadata: Messages::Nothing
      )
    end
    let!(:event1) { Event.from_message!(message1) }
    let!(:event2) { Event.from_message!(message2) }

    it "passes each message for the schema to the provided block" do
      described_class.migrate_event(message_schema:) do |message|
        expect([message1, message2]).to include(message)
      end
    end
  end
end
