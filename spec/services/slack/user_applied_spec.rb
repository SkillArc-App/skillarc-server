require 'rails_helper'

RSpec.describe Slack::UserApplied do
  describe "#call" do
    let(:event) do
      build(
        :events__message,
        :applicant_status_updated,
        aggregate_id: job.id,
        data: Events::ApplicantStatusUpdated::Data::V1.new(
          applicant_id: applicant.id,
          profile_id: profile.id,
          seeker_id: seeker.id,
          user_id: user.id,
          job_id: job.id,
          employer_name: "A employer",
          employment_title: "A title",
          status:
        )
      )
    end
    let(:job) { create(:job) }
    let(:applicant) { create(:applicant, job:, profile:) }
    let(:profile) { create(:profile, user:) }
    let(:seeker) { create(:seeker, user:) }
    let(:user) { create(:user, email: "hannah@blocktrainapp.com") }

    context "status is new" do
      let(:status) { ApplicantStatus::StatusTypes::NEW }

      it "calls the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
          "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{profile.id}|hannah@blocktrainapp.com> has applied to *Welder* at *Acme Inc.*"
        )

        subject.call(event:)
      end
    end

    context "status is not new" do
      let(:status) { ApplicantStatus::StatusTypes::PASS }

      it "does not call the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).not_to receive(:ping)

        subject.call(event:)
      end
    end
  end
end
