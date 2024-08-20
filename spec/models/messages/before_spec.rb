require 'rails_helper'

RSpec.describe Messages::Before do
  describe "#execute" do
    subject do
      described_class.new(message).execute(query_container)
    end

    let(:message) { build(:message, occurred_at: Time.zone.local(2020, 1, 1)) }
    let(:before1) { build(:message, occurred_at: Time.zone.local(2020, 1, 1) - 5.minutes) }
    let(:before2) { build(:message, occurred_at: Time.zone.local(2020, 1, 1) - 10.minutes) }
    let(:after1) { build(:message, occurred_at: Time.zone.local(2020, 1, 1) + 5.minutes) }
    let(:after2) { build(:message, occurred_at: Time.zone.local(2020, 1, 1) + 10.minutes) }
    let(:messages) { [before2, after2] }
    let(:query_container) { build(:messages__query_container, messages:, relation: Event.all) }

    before do
      Event.from_messages!([before1, after1])
    end

    it "returns the appropriate messages" do
      expect(subject.messages).to eq([before2])
      expect(subject.relation.map(&:message)).to eq([before1])
    end
  end
end
