require 'rails_helper'

RSpec.describe Slack::ChatMessage do
  describe "#call" do
    let(:message) do
      build(
        :message,
        :chat_message_sent,
        data: {
          applicant_id: applicant.id,
          seeker_id: seeker.id,
          employer_name: "A name",
          employment_title: "A title",
          message: "A message",
          from_user_id:
        }
      )
    end
    let(:applicant) { create(:applicant, seeker:) }
    let(:seeker) { create(:seeker, user:) }
    let(:user) { create(:user, email: "john@blocktrainapp.com") }

    context "when the applicant is not the sender" do
      let(:from_user_id) { SecureRandom.uuid }

      it "calls the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
          "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{seeker.id}|john@blocktrainapp.com> has *received* a message from *Acme Inc.* for their applcation to *Welder*."
        )

        subject.call(message:)
      end
    end

    context "when the applicant is the sender" do
      let(:from_user_id) { user.id }

      it "calls the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
          "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{seeker.id}|john@blocktrainapp.com> has *sent* a message to *Acme Inc.* for their applcation to *Welder*."
        )

        subject.call(message:)
      end
    end
  end
end
