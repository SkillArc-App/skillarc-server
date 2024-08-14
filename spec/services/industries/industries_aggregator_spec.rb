require 'rails_helper'

RSpec.describe Industries::IndustriesAggregator do
  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject { described_class.new.handle_message(message) }

    context "when the message interests set" do
      let(:message) do
        build(
          :message,
          schema: Industries::Events::IndustriesSet::V1,
          data: {
            industries: %w[cat dog]
          }
        )
      end

      let!(:interests) { create(:industries__industry) }

      it "creates interests" do
        expect { subject }.not_to change(Industries::Industry, :count)

        team = Industries::Industry.first
        expect(team.industries).to eq(message.data.industries)
      end
    end
  end
end
