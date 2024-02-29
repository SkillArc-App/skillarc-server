require 'rails_helper'

RSpec.describe Message do
  describe "#initialize" do
    context "when missing a required key" do
      it "raises a ValueSemantics::MissingAttributes error" do
        expect do
          described_class.new(
            id: SecureRandom.uuid,
            aggregate_id: SecureRandom.uuid,
            trace_id: SecureRandom.uuid,
            message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
            metadata: {},
            version: 1,
            occurred_at: Time.zone.now
          )
        end.to raise_error(ValueSemantics::MissingAttributes)
      end
    end

    context "when a key is of the wrong type" do
      it "raises a ValueSemantics::InvalidValue error" do
        expect do
          described_class.new(
            id: SecureRandom.uuid,
            trace_id: SecureRandom.uuid,
            aggregate_id: 10,
            message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
            metadata: {},
            data: {},
            version: 1,
            occurred_at: Time.zone.now
          )
        end.to raise_error(ValueSemantics::InvalidValue)
      end
    end

    describe "#occurred_at" do
      let(:message) do
        build(
          :message,
          version: Events::DayElapsed::V1.version,
          message_type: Events::DayElapsed::V1.message_type,
          data: Events::DayElapsed::Data::V1.new(
            date: Date.new(2000, 1, 1),
            day_of_week: Events::DayElapsed::Data::DaysOfWeek::WEDNESDAY
          ),
          occurred_at:
        )
      end

      context "when passed a Time for occurred_at" do
        let(:occurred_at) { Time.new(2000, 1, 1, 0, 0, 0, "+00:00") }

        it "converts it to ActiveSupport::TimeWithZone" do
          expect(message.occurred_at).to eq(Time.zone.parse('2000-01-01 00:00:00 UTC'))
        end
      end

      context "when passed a DateTime for occurred_at" do
        let(:occurred_at) { DateTime.new(2000, 1, 1, 0, 0, 0) }

        it "converts it to ActiveSupport::TimeWithZone" do
          expect(message.occurred_at).to eq(Time.zone.parse('2000-01-01 00:00:00 UTC'))
        end
      end

      context "when passed a formatted string string for occurred_at" do
        let(:occurred_at) { "2000-01-01 00:00:00 UTC" }

        it "converts it to ActiveSupport::TimeWithZone" do
          expect(message.occurred_at).to eq(Time.zone.parse('2000-01-01 00:00:00 UTC'))
        end
      end

      context "when passed something else" do
        it "converts it to ActiveSupport::TimeWithZone" do
          expect { build(:message, occurred_at: "Cat o'clock") }.to raise_error(ValueSemantics::InvalidValue)
        end
      end
    end
  end

  describe "#event_schema" do
    context "when the schema doesn't exist" do
      it "raises a EventService::SchemaNotFoundError error" do
        expect do
          described_class.new(
            id: SecureRandom.uuid,
            aggregate_id: SecureRandom.uuid,
            trace_id: SecureRandom.uuid,
            message_type: Messages::Types::APPLICANT_STATUS_UPDATED,
            metadata: {},
            data: {},
            version: -10,
            occurred_at: Time.zone.now
          ).event_schema
        end.to raise_error(MessageService::SchemaNotFoundError)
      end
    end

    context "when the schema does exist" do
      it "returns the schema" do
        message = described_class.new(
          id: SecureRandom.uuid,
          aggregate_id: SecureRandom.uuid,
          trace_id: SecureRandom.uuid,
          message_type: Events::UserCreated::V1.message_type,
          metadata: Messages::Nothing,
          data: Events::UserCreated::Data::V1.new,
          version: Events::UserCreated::V1.version,
          occurred_at: Time.zone.now
        )

        expect(message.schema).to eq(Events::UserCreated::V1)
      end
    end
  end

  describe "#checksum" do
    context "when two events have the same event schema, trace_id, and data payload" do
      it "produces the same checksum for both" do
        trace_id = "c332509e-c2af-3117-b330-7a6adadb74cb"

        message1 = build(
          :message,
          version: Commands::SendSms::V1.version,
          message_type: Commands::SendSms::V1.message_type,
          trace_id:,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "Hello!"
          )
        )

        message2 = build(
          :message,
          version: Commands::SendSms::V1.version,
          message_type: Commands::SendSms::V1.message_type,
          trace_id:,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "Hello!"
          )
        )

        expect(message1.checksum).to eq("f20b3447-b411-3932-9f27-ceb788c712b8")
        expect(message2.checksum).to eq("f20b3447-b411-3932-9f27-ceb788c712b8")
      end
    end

    context "when two event have different trace_ids" do
      it "produces the different checksum for each" do
        trace_id1 = "c332509e-c2af-3117-b330-7a6adadb74cb"
        trace_id2 = "f20b3447-b411-3932-9f27-ceb788c712b8"

        message1 = build(
          :message,
          version: Commands::SendSms::V1.version,
          message_type: Commands::SendSms::V1.message_type,
          trace_id: trace_id1,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "Hello!"
          )
        )

        message2 = build(
          :message,
          version: Commands::SendSms::V1.version,
          message_type: Commands::SendSms::V1.message_type,
          trace_id: trace_id2,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "Hello!"
          )
        )

        expect(message1.checksum).to eq("f20b3447-b411-3932-9f27-ceb788c712b8")
        expect(message2.checksum).to eq("983c312f-09f0-3e29-bbcd-ebdb639cc4e1")
      end
    end

    context "when two event have different payloads" do
      it "produces the different checksum for each" do
        trace_id = "c332509e-c2af-3117-b330-7a6adadb74cb"

        message1 = build(
          :message,
          version: Commands::SendSms::V1.version,
          message_type: Commands::SendSms::V1.message_type,
          trace_id:,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "Hello!"
          )
        )

        message2 = build(
          :message,
          version: Commands::SendSms::V1.version,
          message_type: Commands::SendSms::V1.message_type,
          trace_id:,
          data: Commands::SendSms::Data::V1.new(
            phone_number: "1234567890",
            message: "Hi!"
          )
        )

        expect(message1.checksum).to eq("f20b3447-b411-3932-9f27-ceb788c712b8")
        expect(message2.checksum).to eq("93cbe983-c001-3cdd-9ed3-60b4f0f03447")
      end
    end
  end
end
