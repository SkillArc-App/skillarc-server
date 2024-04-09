require 'rails_helper'

RSpec.describe MessageService do
  describe "#create!" do
    subject do
      described_class.new.create!(
        id:,
        schema:,
        user_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Events::SeekerViewed::Data::V1.new(seeker_id: SecureRandom.uuid) }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Events::ApplicantStatusUpdated::MetaData::V1.new(user_id: SecureRandom.uuid) }
    let(:version) { 4 }
    let(:id) { SecureRandom.uuid }

    context "when the event_schema is not a Messages::Schema" do
      let(:schema) { 10 }

      it "raises a NotEventSchemaError" do
        expect { subject }.to raise_error(described_class::NotEventSchemaError)
      end
    end

    context "when event_schema is a Messages::Schema" do
      let!(:schema) do
        Messages::Schema.active(
          data: Events::SeekerViewed::Data::V1,
          metadata: Events::ApplicantStatusUpdated::MetaData::V1,
          aggregate: Aggregates::User,
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

        it "persists and event and returns the produced event message" do
          expect { subject }.to change(Event, :count).by(1)
          expect(subject.id).to eq(Event.last_created.message.id)
          expect(subject.aggregate_id).to eq(Event.last_created.message.aggregate_id)
          expect(subject.schema).to eq(Event.last_created.message.schema)
          expect(subject.data).to eq(Event.last_created.message.data)
          expect(subject.metadata).to eq(Event.last_created.message.metadata)
          expect(subject.occurred_at).to eq(Event.last_created.message.occurred_at)
        end

        context "when data as a hash type checks" do
          let(:data) { { seeker_id: SecureRandom.uuid } }

          it "persists and event and returns the produced event message" do
            expect { subject }.to change(Event, :count).by(1)
            expect(subject.id).to eq(Event.last_created.message.id)
            expect(subject.aggregate_id).to eq(Event.last_created.message.aggregate_id)
            expect(subject.schema).to eq(Event.last_created.message.schema)
            expect(subject.data).to eq(Event.last_created.message.data)
            expect(subject.metadata).to eq(Event.last_created.message.metadata)
            expect(subject.occurred_at).to eq(Event.last_created.message.occurred_at)
          end
        end

        context "when metadata as a hash type checks" do
          let(:metadata) { { user_id: SecureRandom.uuid } }

          it "persists and event and returns the produced event message" do
            expect { subject }.to change(Event, :count).by(1)
            expect(subject.id).to eq(Event.last_created.message.id)
            expect(subject.aggregate_id).to eq(Event.last_created.message.aggregate_id)
            expect(subject.schema).to eq(Event.last_created.message.schema)
            expect(subject.data).to eq(Event.last_created.message.data)
            expect(subject.metadata).to eq(Event.last_created.message.metadata)
            expect(subject.occurred_at).to eq(Event.last_created.message.occurred_at)
          end
        end

        context "events to publish" do
          subject do
            described_class.new
          end

          before do
            subject
              .create!(
                id:,
                schema:,
                user_id:,
                trace_id:,
                data:,
                occurred_at:,
                metadata:
              )
          end
        end
      end
    end
  end

  describe "#flush" do
    subject { instance.flush }

    let(:instance) { described_class.new }

    let(:message_type) { Messages::Types::CHAT_CREATED }
    let!(:schema) do
      Messages::Schema.active(
        data: Messages::Nothing,
        metadata: Messages::Nothing,
        aggregate: Aggregates::User,
        message_type:,
        version:
      )
    end
    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Messages::Nothing }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Messages::Nothing }
    let(:version) { 4 }
    let(:id) { SecureRandom.uuid }

    before do
      instance
        .create!(
          id:,
          schema:,
          user_id:,
          trace_id:,
          data:,
          occurred_at:,
          metadata:
        )
    end

    it "calls pubsub" do
      expect(PUBSUB_SYNC).to receive(:publish)
      expect(BroadcastEventJob).to receive(:perform_later)

      subject
    end
  end

  describe ".register" do
    subject do
      described_class.register(schema:)
    end

    context "passed something other than a Event::Schema" do
      let(:schema) { { not: "a schema" } }

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
      Messages::Schema.active(
        data: Array,
        metadata: Array,
        aggregate: Aggregates::User,
        message_type: Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST,
        version: 1
      )
    end

    it "returns all registered schemas" do
      expect(subject).to include(schema)
    end
  end

  describe ".all_messages" do
    before do
      Event.from_message!(message1)
      Event.from_message!(message2)
      Event.from_message!(message3)
    end

    let(:message1) do
      build(
        :message,
        schema: Events::MetCareerCoachUpdated::V1,
        data: {
          met_career_coach: false
        }
      )
    end
    let(:message2) do
      build(
        :message,
        schema: Events::MetCareerCoachUpdated::V1,
        data: {
          met_career_coach: false
        }
      )
    end
    let(:message3) do
      build(
        :message,
        schema: Events::SessionStarted::V1
      )
    end

    it "returns all the messages persisted for a schema" do
      expect(described_class.all_messages(Events::MetCareerCoachUpdated::V1)).to contain_exactly(message1, message2)
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
        Messages::Schema.active(
          data: Array,
          metadata: Array,
          aggregate: Aggregates::User,
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
    let(:schema) { Events::UserCreated::V1 }

    let!(:message1) do
      Message.new(
        id: SecureRandom.uuid,
        aggregate: Aggregates::User.new(user_id: SecureRandom.uuid),
        trace_id: SecureRandom.uuid,
        schema:,
        occurred_at: Time.zone.parse('2000-1-1'),
        data: Events::UserCreated::Data::V1.new(first_name: "John"),
        metadata: Messages::Nothing
      )
    end
    let!(:message2) do
      Message.new(
        id: SecureRandom.uuid,
        aggregate: Aggregates::User.new(user_id: SecureRandom.uuid),
        trace_id: SecureRandom.uuid,
        schema:,
        occurred_at: Time.zone.parse('2000-1-1'),
        data: Events::UserCreated::Data::V1.new(first_name: "Chris"),
        metadata: Messages::Nothing
      )
    end
    let!(:event1) { Event.from_message!(message1) }
    let!(:event2) { Event.from_message!(message2) }

    it "passes each message for the schema to the provided block" do
      described_class.migrate_event(schema:) do |message|
        expect([message1, message2]).to include(message)
      end
    end
  end
end
