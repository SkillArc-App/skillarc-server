require 'rails_helper'

RSpec.describe Messages::Schema do
  describe ".active" do
    subject do
      described_class.active(
        data:,
        metadata:,
        message_type:,
        version:,
        aggregate:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }

    it "returns the schema and registers it" do
      expect(MessageService)
        .to receive(:register)
        .with(
          message_schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.active).to eq(true)
      expect(subject.message_type).to eq(message_type)
      expect(subject.version).to eq(version)
      expect(subject.aggregate).to eq(aggregate)
    end
  end

  describe ".deprecated" do
    subject do
      described_class.deprecated(
        data:,
        metadata:,
        message_type:,
        version:,
        aggregate:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }

    it "returns the schema and registers it" do
      expect(MessageService)
        .to receive(:register)
        .with(
          message_schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.active).to eq(false)
      expect(subject.message_type).to eq(message_type)
      expect(subject.version).to eq(version)
      expect(subject.aggregate).to eq(aggregate)
    end
  end

  describe "#all_messages" do
    let(:instance) do
      described_class.active(
        data:,
        metadata:,
        message_type:,
        version:,
        aggregate:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }

    it "passes itself to MessageService.all_messages" do
      expect(MessageService)
        .to receive(:all_messages)
        .with(instance)

      instance.all_messages
    end
  end
end
