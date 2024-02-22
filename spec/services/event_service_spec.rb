require 'rails_helper'

RSpec.describe EventService do
  describe ".create!" do
    subject do
      described_class.create!(
        id:,
        event_schema:,
        aggregate_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:event_type) { Event::EventTypes::CHAT_CREATED }
    let(:aggregate_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Events::Common::UntypedHashWrapper.new(data: "cool") }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Events::Common::UntypedHashWrapper.new(metadata: "cooler") }
    let(:version) { 4 }
    let(:id) { SecureRandom.uuid }

    context "when the event_schema is not a Events::Schema" do
      let(:event_schema) { 10 }

      it "raises a NotEventSchemaError" do
        expect { subject }.to raise_error(described_class::NotEventSchemaError)
      end
    end

    context "when event_schema is a Events::Schema" do
      let!(:event_schema) do
        Events::Schema.build(
          data: Events::Common::UntypedHashWrapper,
          metadata: Events::Common::UntypedHashWrapper,
          event_type:,
          version:
        )
      end

      context "when data doesn't type check" do
        let(:data) { "cat" }
        let(:version) { 1 }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(Events::Message::InvalidSchemaError)
        end
      end

      context "when metadata doesn't type check" do
        let(:metadata) { [1, 2, 3] }
        let(:version) { 2 }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(Events::Message::InvalidSchemaError)
        end
      end

      context "when data and metadata type check" do
        let(:version) { 3 }

        it "enqueues a BroadcastEvent job, persists and event and returns the produced event message" do
          expect(BroadcastEventJob)
            .to receive(:perform_later)
            .with(
              Events::Message.new(
                id:,
                event_type:,
                trace_id:,
                aggregate_id:,
                data:,
                occurred_at:,
                metadata:,
                version:
              )
            )

          expect { subject }.to change(Event, :count).by(1)
          expect(subject.id).to eq(Event.last_created.message.id)
          expect(subject.aggregate_id).to eq(Event.last_created.message.aggregate_id)
          expect(subject.event_type).to eq(Event.last_created.message.event_type)
          expect(subject.data).to eq(Event.last_created.message.data)
          expect(subject.metadata).to eq(Event.last_created.message.metadata)
          expect(subject.version).to eq(Event.last_created.message.version)
          expect(subject.occurred_at).to eq(Event.last_created.message.occurred_at)
        end
      end
    end
  end

  describe ".register" do
    subject do
      described_class.register(event_schema:)
    end

    context "passed something other than a Event::Schema" do
      let(:event_schema) { { not: "a schema" } }

      it "raises a NotSchemaError" do
        expect { subject }.to raise_error(described_class::NotSchemaError)
      end
    end

    context "when passed an Event::Schema" do
      # Can't directly test see the Events::Schema spec
    end
  end

  describe ".get_schema" do
    subject do
      described_class.get_schema(event_type:, version:)
    end

    context "when the schema does not exist" do
      let(:event_type) { "not_a_real_event" }
      let(:version) { 1 }

      it "raises a SchemaNotFoundError" do
        expect { subject }.to raise_error(described_class::SchemaNotFoundError)
      end
    end

    context "when the schema exists" do
      let!(:schema) do
        Events::Schema.build(
          data: Array,
          metadata: Array,
          event_type:,
          version:
        )
      end
      let(:event_type) { "some_event" }
      let(:version) { 1 }

      it "raises a SchemaNotFoundError" do
        expect(subject).to eq(schema)
      end
    end
  end

  describe ".migrate_event" do
    let(:event_schema) { Events::UserCreated::V1 }

    let!(:message1) do
      Events::Message.new(
        id: SecureRandom.uuid,
        aggregate_id: SecureRandom.uuid,
        trace_id: SecureRandom.uuid,
        event_type: event_schema.event_type,
        version: event_schema.version,
        occurred_at: Time.zone.parse('2000-1-1'),
        data: Events::UserCreated::Data::V1.new(first_name: "John"),
        metadata: Events::Common::Nothing
      )
    end
    let!(:message2) do
      Events::Message.new(
        id: SecureRandom.uuid,
        aggregate_id: SecureRandom.uuid,
        trace_id: SecureRandom.uuid,
        event_type: event_schema.event_type,
        version: event_schema.version,
        occurred_at: Time.zone.parse('2000-1-1'),
        data: Events::UserCreated::Data::V1.new(first_name: "Chris"),
        metadata: Events::Common::Nothing
      )
    end
    let!(:event1) { Event.from_message!(message1) }
    let!(:event2) { Event.from_message!(message2) }

    it "passes each message for the schema to the provided block" do
      described_class.migrate_event(event_schema:) do |message|
        expect([message1, message2]).to include(message)
      end
    end
  end
end
