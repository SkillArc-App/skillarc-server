require 'rails_helper'

RSpec.describe Events::Message do
  describe "#initialize" do
    context "when missing a required key" do
      it "raises a ValueSemantics::MissingAttributes error" do
        expect do
          described_class.new(
            id: SecureRandom.uuid,
            aggregate_id: SecureRandom.uuid,
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
      context "when passed a Time for occurred_at" do
        it "converts it to ActiveSupport::TimeWithZone" do
          message = build(:events__message, occurred_at: Time.new(2000, 1, 1, 0, 0, 0, "+00:00"))
          expect(message.occurred_at).to eq(Time.zone.parse('2000-01-01 00:00:00 UTC'))
        end
      end

      context "when passed a DateTime for occurred_at" do
        it "converts it to ActiveSupport::TimeWithZone" do
          message = build(:events__message, occurred_at: DateTime.new(2000, 1, 1, 0, 0, 0))
          expect(message.occurred_at).to eq(Time.zone.parse('2000-01-01 00:00:00 UTC'))
        end
      end

      context "when passed a formatted string string for occurred_at" do
        it "converts it to ActiveSupport::TimeWithZone" do
          message = build(:events__message, occurred_at: "2000-01-01 00:00:00 UTC")
          expect(message.occurred_at).to eq(Time.zone.parse('2000-01-01 00:00:00 UTC'))
        end
      end

      context "when passed something else" do
        it "converts it to ActiveSupport::TimeWithZone" do
          expect { build(:events__message, occurred_at: "Cat o'clock") }.to raise_error(ValueSemantics::InvalidValue)
        end
      end
    end
  end
end
