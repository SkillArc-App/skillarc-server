require 'rails_helper'

RSpec.describe EventService do
  describe ".create!" do
    subject do
      described_class.create!(
        id:,
        event_type:,
        aggregate_id:,
        data:,
        occurred_at:,
        metadata:,
        version:
      )
    end

    let(:event_type) { Event::EventTypes::CHAT_CREATED }
    let(:aggregate_id) { SecureRandom.uuid }
    let(:data) { { data: "cool" } }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:metadata) { { metadata: "cooler" } }
    let(:version) { 4 }
    let(:id) { SecureRandom.uuid }

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
