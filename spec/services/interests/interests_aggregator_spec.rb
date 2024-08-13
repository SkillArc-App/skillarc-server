require 'rails_helper'

RSpec.describe Interests::InterestsAggregator do
  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject { described_class.new.handle_message(message) }

    context "when the message interests set" do
      let(:message) do
        build(
          :message,
          schema: Interests::Events::InterestsSet::V1,
          data: {
            interests: %w[cat dog]
          }
        )
      end

      let!(:interests) { create(:interests__interest) }

      it "creates interests" do
        expect { subject }.not_to change(Interests::Interest, :count)

        team = Interests::Interest.first
        expect(team.interests).to eq(message.data.interests)
      end
    end
  end
end
