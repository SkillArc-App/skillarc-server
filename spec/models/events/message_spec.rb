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
            event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
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
            event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
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
          event_type: Events::DayElapsed::V1.event_type,
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
            event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
            metadata: {},
            data: {},
            version: -10,
            occurred_at: Time.zone.now
          ).event_schema
        end.to raise_error(EventService::SchemaNotFoundError)
      end
    end

    context "when the schema does exist" do
      it "returns the schema" do
        message = described_class.new(
          id: SecureRandom.uuid,
          aggregate_id: SecureRandom.uuid,
          trace_id: SecureRandom.uuid,
          event_type: Events::UserCreated::V1.event_type,
          metadata: Events::Common::Nothing,
          data: Events::UserCreated::Data::V1.new,
          version: Events::UserCreated::V1.version,
          occurred_at: Time.zone.now
        )

        expect(message.event_schema).to eq(Events::UserCreated::V1)
      end
    end
  end
end
