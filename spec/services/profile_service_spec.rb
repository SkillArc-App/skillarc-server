require 'rails_helper'

RSpec.describe ProfileService do
  describe "#update" do
    subject { described_class.new(profile).update(params) }

    let(:profile) { create(:profile) }

    let(:params) do
      {
        bio: "New Bio",
        met_career_coach:
      }
    end
    let(:met_career_coach) { profile.met_career_coach }

    it "updates the profile" do
      expect { subject }
        .to change { profile.reload.bio }.to("New Bio")
    end

    it "publishes a profile updated event" do
      expect(EventService).to receive(:create!).with(
        event_type: Event::EventTypes::PROFILE_UPDATED,
        aggregate_id: profile.user.id,
        data: {
          bio: "New Bio",
          met_career_coach: profile.met_career_coach,
          image: profile.image
        }
      )

      subject
    end

    context "when met_career_coach does not change" do
      it "does not publish a met career coach event" do
        expect(EventService).not_to receive(:create!).with(
          event_type: Event::EventTypes::MET_CAREER_COACH_UPDATED,
          aggregate_id: profile.user.id,
          data: {
            met_career_coach:
          },
          occurred_at: be_present
        )

        subject
      end
    end

    context "when met_career_coach changes" do
      let(:met_career_coach) { !profile.met_career_coach }

      it "creates an event" do
        allow(EventService).to receive(:create!)
        expect(EventService).to receive(:create!).with(
          event_type: Event::EventTypes::MET_CAREER_COACH_UPDATED,
          aggregate_id: profile.user.id,
          data: {
            met_career_coach:
          }
        )

        subject
      end
    end
  end
end
