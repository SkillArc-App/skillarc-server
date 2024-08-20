require 'rails_helper'

RSpec.describe Messages::BySchema do
  describe "#execute" do
    subject do
      described_class.new(schema).execute(query_container)
    end

    let(:schema) { Events::SessionStarted::V1 }
    let(:yes1) { build(:message, schema:) }
    let(:yes2) { build(:message, schema:) }
    let(:no1) { build(:message, schema: Events::UserCreated::V1) }
    let(:no2) { build(:message, schema: Events::UserCreated::V1) }
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
