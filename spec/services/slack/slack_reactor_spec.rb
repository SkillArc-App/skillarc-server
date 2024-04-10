require 'rails_helper'

RSpec.describe Slack::SlackReactor do
  describe "#handle_message" do
    subject { described_class.new(client:).handle_message(message) }

    let(:client) { Slack::FakeClient.new }

    context "when the message is user_created" do
      let(:message) do
        build(
          :message,
          schema: Events::UserCreated::V1,
          aggregate_id: SecureRandom.uuid,
          data: {
            email:
          }
        )
      end
      let(:email) { "some@email.com" }

      it "sends a slack message to the #feed channel" do
        expect(client)
          .to receive(:chat_postMessage)
          .with(
            channel: '#feed',
            text: "New user signed up: *some@email.com*",
            as_user: true
          )

        subject
      end
    end

    context "when the message is applicant status updated" do
      let(:message) do
        build(
          :message,
          schema: Events::ApplicantStatusUpdated::V5,
          data: {
            applicant_id: SecureRandom.uuid,
            applicant_first_name: "John",
            applicant_last_name: "Chabot",
            applicant_email: "john@skillarc.com",
            seeker_id: "d9956e79-c5f3-41c8-9150-9fa799e0f33f",
            user_id: SecureRandom.uuid,
            job_id: SecureRandom.uuid,
            employer_name: "Employer",
            employment_title: "A title",
            status:
          },
          metadata: {
            user_id: SecureRandom.uuid
          }
        )
      end

      context "when the applicant status is not new" do
        let(:status) { ApplicantStatus::StatusTypes::PASS }

        it "does not send a message" do
          expect(client)
            .not_to receive(:chat_postMessage)

          subject
        end
      end

      context "when the applicant status is new" do
        let(:status) { ApplicantStatus::StatusTypes::NEW }

        it "does not send a message" do
          expect(client)
            .to receive(:chat_postMessage)
            .with(
              channel: '#feed',
              text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/d9956e79-c5f3-41c8-9150-9fa799e0f33f|john@skillarc.com> has applied to *A title* at *Employer*",
              as_user: true
            )

          subject
        end
      end
    end

    context "when the message is chat message sent" do
      let(:message) do
        build(
          :message,
          schema: Events::ChatMessageSent::V1,
          data: {
            applicant_id: SecureRandom.uuid,
            seeker_id: seeker.id,
            from_user_id:,
            employer_name: "Employer",
            employment_title: "A job",
            message: "yo"
          }
        )
      end

      let(:user) { create(:user, email: "some@email.com") }
      let(:seeker) { create(:seeker, user:) }

      context "when the from_user_id is the seeker" do
        let(:from_user_id) { seeker.user_id }

        it "sends a slack message to the #feed channel" do
          expect(client)
            .to receive(:chat_postMessage)
            .with(
              channel: '#feed',
              text: "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{seeker.id}|some@email.com> has *sent* a message to *Employer* for their applcation to *A job*.",
              as_user: true
            )

          subject
        end
      end

      context "when the from_user_id is not the seeker" do
        let(:from_user_id) { SecureRandom.uuid }

        it "sends a slack message to the #feed channel" do
          expect(client)
            .to receive(:chat_postMessage)
            .with(
              channel: '#feed',
              text: "Applicant <#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{seeker.id}|some@email.com> has *received* a message from *Employer* for their applcation to *A job*.",
              as_user: true
            )

          subject
        end
      end
    end
  end
end
