require 'rails_helper'

RSpec.describe Messages::Query do
  let(:query_container) { build(:messages__query_container) }

  describe "#by_stream" do
    subject do
      described_class.new(query_container:).by_stream(stream)
    end

    let(:stream) { Users::Streams::User.new(user_id: SecureRandom.uuid) }

    it "creates a new query with a ByStream filter" do
      expect(subject.query_container).to eq(query_container)
      expect(subject.filters.length).to eq(1)
      expect(subject.filters[0]).to be_a(Messages::ByStream)
    end
  end

  describe "#by_trace" do
    subject do
      described_class.new(query_container:).by_trace(trace_id)
    end

    let(:trace_id) { SecureRandom.uuid }

    it "creates a new query with a ByTrace filter" do
      expect(subject.query_container).to eq(query_container)
      expect(subject.filters.length).to eq(1)
      expect(subject.filters[0]).to be_a(Messages::ByTrace)
    end
  end

  describe "#by_schema" do
    subject do
      described_class.new(query_container:).by_schema(schema)
    end

    let(:schema) { Users::Events::SessionStarted::V1 }

    it "creates a new query with a ByTrace filter" do
      expect(subject.query_container).to eq(query_container)
      expect(subject.filters.length).to eq(1)
      expect(subject.filters[0]).to be_a(Messages::BySchema)
    end
  end

  describe "#before" do
    subject do
      described_class.new(query_container:).before(message)
    end

    let(:message) { build(:message) }

    it "creates a new query with a ByTrace filter" do
      expect(subject.query_container).to eq(query_container)
      expect(subject.filters.length).to eq(1)
      expect(subject.filters[0]).to be_a(Messages::Before)
    end
  end

  describe "#fetch" do
    subject do
      described_class.new(trace_id).execute(query_container)
    end
  end
end
