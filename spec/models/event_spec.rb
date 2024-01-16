require 'rails_helper'

RSpec.describe Event do
  describe "#message" do
    subject { event.message }

    let(:event) { build(:event) }

    it "creates an EventMessage with the same data" do
      expect(subject).to be_a(EventMessage)

      expect(subject.id).to eq(event.id)
      expect(subject.aggregate_id).to eq(event.aggregate_id)
      expect(subject.event_type).to eq(event.event_type)
      expect(subject.data).to eq(event.data)
      expect(subject.metadata).to eq(event.metadata)
      expect(subject.version).to eq(event.version)
      expect(subject.occurred_at).to eq(event.occurred_at)
    end
  end

  describe ".from_message" do
    subject { described_class.from_message(event_message) }

    let(:event_message) { build(:event_message) }

    it "creates an EventMessage with the same data" do
      expect(subject).to be_a(described_class)

      expect(subject.id).to eq(event_message.id)
      expect(subject.aggregate_id).to eq(event_message.aggregate_id)
      expect(subject.event_type).to eq(event_message.event_type)
      expect(subject.data).to eq(event_message.data)
      expect(subject.metadata).to eq(event_message.metadata)
      expect(subject.version).to eq(event_message.version)
      expect(subject.occurred_at).to eq(event_message.occurred_at)
    end
  end
end
