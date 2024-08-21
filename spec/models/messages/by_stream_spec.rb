require 'rails_helper'

RSpec.describe Messages::ByStream do
  describe "#execute" do
    subject do
      described_class.new(stream).execute(query_container)
    end

    let(:schema) { Events::SessionStarted::V1 }
    let(:yes1) { build(:message, stream:) }
    let(:yes2) { build(:message, stream:) }
    let(:no1) { build(:message) }
    let(:no2) { build(:message) }
    let(:stream) { Streams::User.new(user_id: SecureRandom.uuid) }
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
