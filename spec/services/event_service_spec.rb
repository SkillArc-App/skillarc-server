require 'rails_helper'

RSpec.describe EventService do
  describe ".create!" do
    subject do
      described_class.create!(
        id:,
        event_schema:,
        aggregate_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:event_type) { Event::EventTypes::CHAT_CREATED }
    let(:aggregate_id) { SecureRandom.uuid }
    let(:data) { { data: "cool" } }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { { metadata: "cooler" } }
    let(:version) { 4 }
    let(:id) { SecureRandom.uuid }

    context "when the event_schema is not a Events::Schema" do
      let(:event_schema) { 10 }

      it "raises a NotEventSchemaError" do
        expect { subject }.to raise_error(described_class::NotEventSchemaError)
      end
    end

    context "when event_schema is a Events::Schema" do
      let(:event_schema) do
        Events::Schema.new(
          data: Hash,
          metadata: Hash,
          event_type:,
          version:
        )
      end

      context "when data doesn't type check" do
        let(:data) { "cat" }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(described_class::InvalidSchemaError)
        end
      end

      context "when metadata doesn't type check" do
        let(:metadata) { [1, 2, 3] }

        it "raies a InvalidSchemaError" do
          expect { subject }.to raise_error(described_class::InvalidSchemaError)
        end
      end

      context "when data and metadata type check" do
        it "enqueues a BroadcastEvent job, persists and event and returns the produced event message" do
          expect(BroadcastEventJob)
            .to receive(:perform_later)
            .with(
              Events::Message.new(
                id:,
                event_type:,
                aggregate_id:,
                data:,
                occurred_at:,
                metadata:,
                version:
              )
            )

          expect { subject }.to change(Event, :count).by(1)
          expect(subject).to eq(Event.last_created.message)
        end
      end
    end
  end
end
