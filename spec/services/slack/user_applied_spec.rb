require 'rails_helper'

RSpec.describe Slack::UserApplied do
  describe "#call" do
    let(:message) do
      build(
        :message,
        :applicant_status_updated,
        version: 3,
        aggregate_id: job.id,
        data: {
          applicant_id: applicant.id,
          applicant_first_name: "John",
          applicant_last_name: "Chabot",
          applicant_email: "john@skillar.com",
          seeker_id: seeker.id,
          user_id: user.id,
          job_id: job.id,
          employer_name: "A employer",
          employment_title: "A title",
          status:,
          reasons: [
            Events::ApplicantStatusUpdated::Reason::V1.new(
              id: SecureRandom.uuid,
              response: "Applicant sucks"
            )
          ]
        }
      )
    end
    let(:job) { create(:job) }
    let(:applicant) { create(:applicant, job:, seeker:) }
    let(:seeker) { create(:seeker, user:) }
    let(:user) { create(:user, email: "hannah@blocktrainapp.com") }

    context "status is new" do
      let(:status) { ApplicantStatus::StatusTypes::NEW }

      it "calls the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
          "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{seeker.id}|hannah@blocktrainapp.com> has applied to *Welder* at *Acme Inc.*"
        )

        subject.call(message:)
      end
    end

    context "status is not new" do
      let(:status) { ApplicantStatus::StatusTypes::PASS }

      it "does not call the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).not_to receive(:ping)

        subject.call(message:)
      end
    end
  end
end
