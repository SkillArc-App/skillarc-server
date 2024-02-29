require 'rails_helper'

RSpec.describe Messages::Schema do
  describe ".build" do
    before(:each) do
      stub_const("Messages::Types::Coaches::LEAD_ADDED", "test_event_name-#{SecureRandom.uuid}")
    end

    subject do
      described_class.build(
        data:,
        metadata:,
        message_type:,
        version:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::Coaches::LEAD_ADDED }
    let(:version) { 1 }

    it "returns the schema and registers it" do
      expect(MessageService)
        .to receive(:register)
        .with(
          message_schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.message_type).to eq(message_type)
      expect(subject.version).to eq(version)
    end
  end
end
