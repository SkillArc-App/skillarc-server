require 'rails_helper'

RSpec.describe Messages::Schema do
  describe ".build" do
    before(:each) do
      stub_const("Event::EventTypes::LEAD_ADDED", "test_event_name-#{SecureRandom.uuid}")
    end

    subject do
      described_class.build(
        data:,
        metadata:,
        event_type:,
        version:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:event_type) { Event::EventTypes::LEAD_ADDED }
    let(:version) { 1 }

    it "returns the schema and registers it" do
      expect(EventService)
        .to receive(:register)
        .with(
          event_schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.event_type).to eq(event_type)
      expect(subject.version).to eq(version)
    end
  end
end
