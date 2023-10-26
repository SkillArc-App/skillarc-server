require 'rails_helper'

RSpec.describe Slack::UserApplied do
  describe "#call" do
    let(:event) do
      build(
        :event,
        :applicant_status_updated,
        aggregate_id: job.id,
        data: {
          applicant_id: applicant.id,
          status:
        }
      )
    end
    let(:job) { create(:job) }
    let(:applicant) { create(:applicant, job: job, profile: profile ) }
    let(:profile) { create(:profile, user: user) }
    let(:user) { create(:user, email: "hannah@blocktrainapp.com" ) }

    context "status is new" do
      let(:status) { ApplicantStatus::StatusTypes::NEW }

      it "calls the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to receive(:ping).with(
          "<localhost:3000/profiles/#{profile.id}|hannah@blocktrainapp.com> has applied to *Welder* at *Acme Inc.*"
        )

        subject.call(event:)
      end
    end

    context "status is not new" do
      let(:status) { "not_new" }

      it "does not call the Slack API" do
        expect_any_instance_of(Slack::FakeSlackGateway).to_not receive(:ping)

        subject.call(event:)
      end
    end
  end
end