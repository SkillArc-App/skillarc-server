require 'rails_helper'

RSpec.describe Messages::ByTrace do
  describe "#execute" do
    subject do
      described_class.new(trace_id).execute(query_container)
    end

    let(:trace_id) { SecureRandom.uuid }
    let(:yes1) { build(:message, trace_id:) }
    let(:yes2) { build(:message, trace_id:) }
    let(:no1) { build(:message) }
    let(:no2) { build(:message) }
    let(:messages) { [yes2, no2] }
    let(:query_container) { build(:messages__query_container, messages:, relation: Event.all) }

    before do
      Event.from_messages!([yes1, no1])
    end

    it "returns the appropriate messages" do
      expect(subject.messages).to eq([yes2])
      expect(subject.relation.map(&:message)).to eq([yes1])
    end
  end
end
