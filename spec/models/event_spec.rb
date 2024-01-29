require 'rails_helper'

RSpec.describe Event do
  describe "#message" do
    subject { event.message }

    let(:event) { build(:event, data: { cat: 1 }, metadata: { dog: 2 }) }

    it "creates an Events::Message with the same data" do
      expect(subject).to be_a(Events::Message)

      expect(subject.id).to eq(event[:id])
      expect(subject.aggregate_id).to eq(event[:aggregate_id])
      expect(subject.event_type).to eq(event[:event_type])
      expect(subject.data).to eq(event[:data].deep_symbolize_keys)
      expect(subject.metadata).to eq(event[:metadata].deep_symbolize_keys)
      expect(subject.version).to eq(event[:version])
      expect(subject.occurred_at).to eq(event[:occurred_at])
    end
  end

  describe ".from_message!" do
    subject { described_class.from_message!(events__message) }

    let(:events__message) { build(:events__message, data: { cat: 1 }, metadata: { dog: 2 }) }

    it "creates an Events::Message with the same data" do
      expect(subject).to be_a(described_class)

      expect(subject[:id]).to eq(events__message.id)
      expect(subject[:aggregate_id]).to eq(events__message.aggregate_id)
      expect(subject[:event_type]).to eq(events__message.event_type)
      expect(subject[:data].deep_symbolize_keys).to eq(events__message.data)
      expect(subject[:metadata].deep_symbolize_keys).to eq(events__message.metadata)
      expect(subject[:version]).to eq(events__message.version)
      expect(subject[:occurred_at]).to eq(events__message.occurred_at)
    end
  end
end
