require 'rails_helper'

RSpec.describe Messages::Schema do
  describe ".active" do
    subject do
      described_class.active(
        data:,
        metadata:,
        message_type:,
        version:,
        stream:,
        type:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }
    let(:type) { Messages::EVENT }

    it "returns the schema and registers it" do
      expect(MessageService)
        .to receive(:register)
        .with(
          schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.status).to eq(described_class::Status::ACTIVE)
      expect(subject.message_type).to eq(message_type)
      expect(subject.version).to eq(version)
      expect(subject.stream).to eq(aggregate)
    end
  end

  describe ".deprecated" do
    subject do
      described_class.deprecated(
        data:,
        metadata:,
        message_type:,
        version:,
        stream:,
        type:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }
    let(:type) { Messages::EVENT }

    it "returns the schema and registers it" do
      expect(MessageService)
        .to receive(:register)
        .with(
          schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.status).to eq(described_class::Status::DEPRECATED)
      expect(subject.message_type).to eq(message_type)
      expect(subject.version).to eq(version)
      expect(subject.stream).to eq(aggregate)
    end
  end

  describe ".inactive" do
    subject do
      described_class.inactive(
        data:,
        metadata:,
        message_type:,
        version:,
        stream:,
        type:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }
    let(:type) { Messages::EVENT }

    it "returns the schema and registers it" do
      expect(MessageService)
        .to receive(:register)
        .with(
          schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.status).to eq(described_class::Status::INACTIVE)
      expect(subject.message_type).to eq(message_type)
      expect(subject.version).to eq(version)
      expect(subject.stream).to eq(aggregate)
    end
  end

  describe ".destroy!" do
    subject do
      described_class.destroy!(
        data:,
        metadata:,
        message_type:,
        version:,
        stream:,
        type:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }
    let(:type) { Messages::EVENT }

    it "returns the schema and registers it" do
      expect(MessageService)
        .to receive(:register)
        .with(
          schema: be_a(described_class)
        ).and_call_original

      expect(subject.data).to eq(data)
      expect(subject.metadata).to eq(metadata)
      expect(subject.status).to eq(described_class::Status::DESTROYED)
      expect(subject.message_type).to eq(message_type)
      expect(subject.version).to eq(version)
      expect(subject.stream).to eq(aggregate)
    end
  end

  describe "#all_messages" do
    let(:instance) do
      described_class.active(
        data:,
        metadata:,
        message_type:,
        version:,
        stream:,
        type:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }
    let(:type) { Messages::EVENT }

    it "passes itself to MessageService.all_messages" do
      expect(MessageService)
        .to receive(:all_messages)
        .with(instance)

      instance.all_messages
    end
  end

  describe "#serialize" do
    let(:instance) do
      described_class.active(
        data:,
        metadata:,
        message_type:,
        version:,
        stream:,
        type:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }
    let(:type) { Messages::EVENT }

    it "just returns the message_type and version" do
      expect(instance.serialize).to eq({ version:, message_type: })
    end
  end

  describe "#deserialize" do
    let!(:instance) do
      described_class.active(
        data:,
        metadata:,
        message_type:,
        version:,
        stream:,
        type:
      )
    end

    let(:data) { String }
    let(:metadata) { Hash }
    let(:type) { Messages::EVENT }
    let(:message_type) { Messages::Types::TestingOnly::TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST }
    let(:version) { 1 }
    let(:aggregate) { Aggregates::User }

    it "just returns the message_type and version" do
      expect(described_class.deserialize({ version:, message_type: })).to eq(instance)
    end
  end
end
