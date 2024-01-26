require 'rails_helper'

RSpec.describe Klayvio::ChatMessageReceived do
  describe "#call" do
    subject { described_class.new.call(event:) }

    let(:event) do
      build(
        :events__message,
        :chat_message_sent,
        aggregate_id: job.id,
        data: {
          applicant_id: applicant.id,
          profile_id: applicant.profile.id,
          from_user_id: sender_id
        },
        occurred_at:
      )
    end
    let(:email) { "chabot@blocktrain.com" }
    let(:user) { create(:user, email:) }
    let(:occurred_at) { Time.zone.local(2020, 1, 1) }
    let(:job) { create(:job) }
    let(:applicant) { create(:applicant, profile:) }
    let(:profile) { create(:profile, user:) }

    context "when the sender is the applicant" do
      let(:sender_id) { applicant.profile.user.id }

      it "does not call the Klayvio API" do
        expect_any_instance_of(Klayvio::Klayvio).not_to receive(:chat_message_received)

        subject
      end
    end

    context "when the sender is not the applicant" do
      let(:sender_id) { sender_user.id }
      let(:sender_user) { create(:user) }

      it "calls the Klayvio API" do
        expect_any_instance_of(Klayvio::Klayvio).to receive(:chat_message_received).with(
          email:,
          event_id: event.id,
          occurred_at:,
          applicant_id: applicant.id,
          employment_title: job.employment_title,
          employer_name: job.employer.name
        )

        subject
      end
    end
  end
end
