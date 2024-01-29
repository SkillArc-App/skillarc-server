require 'rails_helper'

RSpec.describe Slack::ChatMessage do
  describe "#call" do
    let(:event) do
      build(
        :events__message,
        :chat_message_sent,
        data: {
          applicant_id: applicant.id,
          from_user_id:
        }
      )
    end
    let(:applicant) { create(:applicant, profile:) }
    let(:profile) { create(:profile, user:) }
    let(:user) { create(:user, email: "john@blocktrainapp.com") }

    context "when the applicant is not the sender" do
      let(:from_user_id) { "not_the_user_id" }

      it "calls the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
          "Applicant <#{ENV['FRONTEND_URL']}/profiles/#{profile.id}|john@blocktrainapp.com> has *received* a message from *Acme Inc.* for their applcation to *Welder*."
        )

        subject.call(event:)
      end
    end

    context "when the applicant is the sender" do
      let(:from_user_id) { user.id }

      it "calls the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
          "Applicant <#{ENV['FRONTEND_URL']}/profiles/#{profile.id}|john@blocktrainapp.com> has *sent* a message to *Acme Inc.* for their applcation to *Welder*."
        )

        subject.call(event:)
      end
    end
  end
end
