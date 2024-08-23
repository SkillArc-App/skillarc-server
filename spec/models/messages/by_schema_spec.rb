require 'rails_helper'

RSpec.describe Messages::BySchema do
  describe "#execute" do
    subject do
      described_class.new(schema, active_only:).execute(query_container)
    end

    let(:active_only) { true }
    let(:schema) { Users::Events::SessionStarted::V1 }
    let(:yes1) { build(:message, schema:) }
    let(:yes2) { build(:message, schema:) }
    let(:no1) { build(:message, schema: Users::Events::UserCreated::V1) }
    let(:no2) { build(:message, schema: Users::Events::UserCreated::V1) }
    let(:messages) { [yes2, no2] }
    let(:query_container) { build(:messages__query_container, messages:, relation: Event.all) }

    before do
      Event.from_messages!([yes1, no1])
    end

    it "returns the appropriate messages" do
      expect(subject.messages).to eq([yes2])
      expect(subject.relation.map(&:message)).to eq([yes1])
    end

    context "when an inactive schema is provided and active only is true" do
      let(:active_only) { true }

      it "raises a QueriedInactiveSchemaError" do
        expect { described_class.new(Commands::AddSeeker::V1, active_only:).execute(query_container) }.to raise_error(described_class::QueriedInactiveSchemaError)
      end
    end

    context "when an inactive schema is provided and active only is false" do
      let(:active_only) { false }

      it "does not raise error" do
        expect { described_class.new(Commands::AddSeeker::V1, active_only:).execute(query_container) }.not_to raise_error
      end
    end
  end
end
