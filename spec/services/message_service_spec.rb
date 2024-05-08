require 'rails_helper'

RSpec.describe MessageService do # rubocop:disable Metrics/BlockLength
  let(:instance) { described_class.new }
  let!(:schema) do
    Messages::Schema.active(
      data: Events::SeekerViewed::Data::V1,
      metadata: Events::ApplicantStatusUpdated::MetaData::V1,
      aggregate: Aggregates::User,
      message_type:,
      version:,
      type:
    )
  end
  let(:type) { Messages::EVENT }
  let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
  let(:version) { 3 }

  describe "#create_once_for_aggregate!" do
    subject do
      instance.create_once_for_aggregate!(
        id:,
        schema:,
        user_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Events::SeekerViewed::Data::V1.new(seeker_id: SecureRandom.uuid) }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Events::ApplicantStatusUpdated::MetaData::V1.new(user_id: SecureRandom.uuid) }
    let(:id) { SecureRandom.uuid }

    context "when the event has not already occurred" do
      it "calls build and save!" do
        expect(instance)
          .to receive(:build)
          .with(
            schema:,
            data:,
            aggregate: Aggregates::User.new(user_id:),
            trace_id:,
            id:,
            occurred_at:,
            metadata:,
            user_id:
          )
          .and_call_original

        expect(instance)
          .to receive(:save!)
          .with(
            Message.new(
              schema:,
              data:,
              trace_id:,
              id:,
              occurred_at:,
              metadata:,
              aggregate: Aggregates::User.new(user_id:)
            )
          )
          .and_call_original

        subject
      end
    end

    context "when the event has already occured" do
      before do
        expect(described_class)
          .to receive(:aggregate_events)
          .with(Aggregates::User.new(user_id:))
          .and_return([
                        build(
                          :message,
                          schema:,
                          data: {
                            seeker_id: SecureRandom.uuid
                          },
                          metadata: {
                            user_id: SecureRandom.uuid
                          }
                        )
                      ])
      end

      it "calls build but not save!" do
        expect(instance)
          .to receive(:build)
          .with(
            schema:,
            data:,
            aggregate: Aggregates::User.new(user_id:),
            trace_id:,
            id:,
            occurred_at:,
            metadata:,
            user_id:
          )
          .and_call_original

        expect(instance)
          .not_to receive(:save!)

        subject
      end
    end
  end

  describe "#create_once!" do
    subject do
      instance.create_once_for_aggregate!(
        id:,
        schema:,
        user_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:,
        projector:
      )
    end

    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Events::SeekerViewed::Data::V1.new(seeker_id: SecureRandom.uuid) }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Events::ApplicantStatusUpdated::MetaData::V1.new(user_id: SecureRandom.uuid) }
    let(:id) { SecureRandom.uuid }

    context "when the projector returns a boolean" do
      let(:projector) { Projections::Aggregates::HasOccurred.new(aggregate: Aggregates::User.new(user_id:), schema:) }

      it "calls build and save!" do
        expect(instance)
          .to receive(:build)
          .with(
            schema:,
            data:,
            aggregate: Aggregates::User.new(user_id:),
            trace_id:,
            id:,
            occurred_at:,
            metadata:,
            user_id:
          )
          .and_call_original

        expect(instance)
          .to receive(:save!)
          .with(
            Message.new(
              schema:,
              data:,
              trace_id:,
              id:,
              occurred_at:,
              metadata:,
              aggregate: Aggregates::User.new(user_id:)
            )
          )
          .and_call_original

        subject
      end
    end

    context "when the projector does not returns a boolean" do
      let(:projector) { Projections::Aggregates::GetFirst.new(aggregate: Aggregates::User.new(user_id:), schema:) }

      it "calls build and save!" do
        expect { subject }.to raise_error(described_class::NotBooleanProjection)
      end
    end
  end

  describe "#create!" do
    subject do
      instance.create!(
        id:,
        schema:,
        user_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Events::SeekerViewed::Data::V1.new(seeker_id: SecureRandom.uuid) }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Events::ApplicantStatusUpdated::MetaData::V1.new(user_id: SecureRandom.uuid) }
    let(:id) { SecureRandom.uuid }

    it "calls build and save!" do
      expect(instance)
        .to receive(:build)
        .with(
          schema:,
          data:,
          aggregate: nil,
          trace_id:,
          id:,
          occurred_at:,
          metadata:,
          user_id:
        )
        .and_call_original

      expect(instance)
        .to receive(:save!)
        .with(
          Message.new(
            schema:,
            data:,
            trace_id:,
            id:,
            occurred_at:,
            metadata:,
            aggregate: Aggregates::User.new(user_id:)
          )
        )
        .and_call_original

      subject
    end
  end

  describe "#build" do
    subject do
      instance.build(
        id:,
        schema:,
        user_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Events::SeekerViewed::Data::V1.new(seeker_id: SecureRandom.uuid) }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { Events::ApplicantStatusUpdated::MetaData::V1.new(user_id: SecureRandom.uuid) }
    let(:id) { SecureRandom.uuid }

    context "when the event_schema is not a Messages::Schema" do
      let(:schema) { 10 }

      it "raises a NotSchemaError" do
        expect { subject }.to raise_error(described_class::NotSchemaError)
      end
    end

    context "when event_schema is a Messages::Schema" do
      context "when data doesn't type check" do
        let(:data) { "cat" }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(Message::InvalidSchemaError)
        end
      end

      context "when metadata doesn't type check" do
        let(:metadata) { [1, 2, 3] }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(Message::InvalidSchemaError)
        end
      end

      context "when data and metadata type check" do
        it "returns the produced message" do
          expect(subject.id).to eq(id)
          expect(subject.aggregate_id).to eq(user_id)
          expect(subject.schema).to eq(schema)
          expect(subject.data).to eq(data)
          expect(subject.metadata).to eq(metadata)
          expect(subject.occurred_at).to eq(occurred_at)
        end

        context "when data as a hash type checks" do
          let(:data) { { seeker_id: SecureRandom.uuid } }

          it "returns the produced message" do
            expect(subject.id).to eq(id)
            expect(subject.aggregate_id).to eq(user_id)
            expect(subject.schema).to eq(schema)
            expect(subject.data).to eq(Events::SeekerViewed::Data::V1.new(seeker_id: data[:seeker_id]))
            expect(subject.metadata).to eq(metadata)
            expect(subject.occurred_at).to eq(occurred_at)
          end
        end

        context "when metadata as a hash type checks" do
          let(:metadata) { { user_id: SecureRandom.uuid } }

          it "returns the produced message" do
            expect(subject.id).to eq(id)
            expect(subject.aggregate_id).to eq(user_id)
            expect(subject.schema).to eq(schema)
            expect(subject.data).to eq(data)
            expect(subject.metadata).to eq(Events::ApplicantStatusUpdated::MetaData::V1.new(user_id: metadata[:user_id]))
            expect(subject.occurred_at).to eq(occurred_at)
          end
        end
      end
    end
  end

  describe "#save!" do
    subject do
      instance.save!(message)
    end

    let(:message) do
      build(
        :message,
        schema:,
        aggregate_id: SecureRandom.uuid,
        data: {
          coach_email: "coach@skillarc.com"
        }
      )
    end
    let(:schema) { Commands::AssignCoach::V1 }
    let(:schema_string) { schema.to_s }

    it "persists the message" do
      expect { subject }.to change(Event, :count).by(1)
      expect(message.id).to eq(Event.last_created.message.id)
      expect(message.aggregate_id).to eq(Event.last_created.message.aggregate_id)
      expect(message.schema).to eq(Event.last_created.message.schema)
      expect(message.data).to eq(Event.last_created.message.data)
      expect(message.metadata).to eq(Event.last_created.message.metadata)
      expect(message.occurred_at).to eq(Event.last_created.message.occurred_at)
    end

    it "queues the message to be published" do
      allow(instance)
        .to receive(:broadcast?)
        .and_return(true)

      expect(PUBSUB_SYNC)
        .to receive(:publish)
        .with(schema_string:)

      expect(BroadcastEventJob)
        .to receive(:perform_later)
        .with(schema_string)

      subject

      instance.flush
    end
  end

  describe "#flush" do
    subject { instance.flush }

    let(:user_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { { seeker_id: SecureRandom.uuid } }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { { user_id: SecureRandom.uuid } }
    let(:id) { SecureRandom.uuid }

    before do
      allow(instance)
        .to receive(:broadcast?)
        .and_return(true)

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

    context "when passed an existing registered schema" do
      let(:schema) { Events::UserCreated::V1 }

      it "raises a SchemaAlreadyDefinedError" do
        expect { subject }.to raise_error(described_class::SchemaAlreadyDefinedError)
      end
    end

    context "when passed a 2nd active schema for the same message type" do
      it "raise a MessageTypeHasMultipleActiveSchemas" do
        expect do
          Messages::Schema.active(
            data: Messages::Nothing,
            metadata: Messages::Nothing,
            aggregate: Aggregates::User,
            message_type: Messages::Types::User::USER_CREATED,
            type: Messages::EVENT,
            version: 2
          )
        end.to raise_error(described_class::MessageTypeHasMultipleActiveSchemas)
      end
    end
  end

  describe ".all_schemas" do
    subject { described_class.all_schemas }

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

    context "when schema is a schema" do
      it "returns all the messages persisted for a schema" do
        expect(described_class.all_messages(Events::MetCareerCoachUpdated::V1)).to contain_exactly(message1, message2)
      end
    end

    context "when schema is not a schema" do
      it "raises a NotSchemaError" do
        expect { expect(described_class.all_messages(10)) }.to raise_error(described_class::NotSchemaError)
      end
    end
  end

  describe ".aggregate_events" do
    before do
      Event.from_message!(message1)
      Event.from_message!(message2)
      Event.from_message!(message3)
    end

    let(:message_id) { SecureRandom.uuid }
    let(:message1) do
      build(
        :message,
        aggregate_id: message_id,
        schema: Events::MessageSent::V1,
        data: Messages::Nothing,
        occurred_at: Time.zone.local(2021, 1, 1)
      )
    end
    let(:message2) do
      build(
        :message,
        aggregate_id: message_id,
        schema: Events::SlackMessageSent::V1,
        data: {
          channel: "#cool",
          text: "Sup"
        },
        occurred_at: Time.zone.local(2020, 1, 1)
      )
    end
    let(:message3) do
      build(
        :message,
        aggregate_id: message_id,
        schema: Commands::SendSlackMessage::V1,
        data: {
          channel: "#cool",
          text: "Sup"
        },
        occurred_at: Time.zone.local(2020, 1, 1)
      )
    end

    context "when aggregate is a aggregate" do
      it "returns all the events for the aggregate in order" do
        expect(described_class.aggregate_events(Aggregates::Message.new(message_id:))).to eq([message2, message1])
      end
    end

    context "when aggregate is not a aggregate" do
      it "raises a NotSchemaError" do
        expect { described_class.aggregate_events("cat") }.to raise_error(described_class::NotAggregateError)
      end
    end
  end

  describe ".get_schema" do
    subject do
      described_class.get_schema(message_type:, version:)
    end

    context "when the schema does not exist" do
      it "raises a SchemaNotFoundError" do
        expect { described_class.get_schema(message_type: "not_a_real_event", version:) }.to raise_error(described_class::SchemaNotFoundError)
      end
    end

    context "when the schema exists" do
      it "returns the schema" do
        expect(described_class.get_schema(message_type:, version:)).to eq(schema)
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
