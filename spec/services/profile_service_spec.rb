require 'rails_helper'

RSpec.describe ProfileService do
  describe "#update" do
    subject { described_class.new(profile).update(params) }

    let(:profile) { create(:profile) }

    let(:params) do
      {
        bio: "New Bio",
        met_career_coach:,
      }
    end
    let(:met_career_coach) { profile.met_career_coach }

    it "updates the profile" do
      expect { subject }
        .to change { profile.reload.bio }.to("New Bio")
    end

    context "when met_career_coach does not change" do
      it "does not publish" do
        expect(Resque).not_to receive(:enqueue)

        subject
      end
    end

    context "when met_career_coach changes" do
      let(:met_career_coach) { !profile.met_career_coach }

      it "creates an event" do
        expect_any_instance_of(Resque).to receive(:enqueue).with(
          CreateEventJob,
          event_type: Event::EventTypes::MET_CAREER_COACH_UPDATED,
          aggregate_id: profile.user.id,
          data: {
            met_career_coach: met_career_coach,
          },
          occurred_at: be_present,
          metadata: {}
        )

        subject
      end
    end
  end
end