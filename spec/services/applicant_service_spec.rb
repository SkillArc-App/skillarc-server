require 'rails_helper'

RSpec.describe ApplicantService do
  let(:applicant) { create(:applicant) }
  let!(:search_job) { create(:search__job, job_id: applicant.job.id) }

  describe "#update_status" do
    subject { described_class.new(applicant).update_status(status:, user_id:, reasons:) }

    include_context "event emitter", false

    let(:status) { ApplicantStatus::StatusTypes::PENDING_INTRO }
    let(:reasons) { [{ id: reason.id, response: "Bad canidate" }] }
    let(:reason) { create(:reason) }
    let(:user_id) { SecureRandom.uuid }

    it "creates a new applicant status" do
      expect do
        subject
      end.to change { applicant.reload.applicant_statuses.count }.by(1)

      expect(applicant.status.status).to eq(ApplicantStatus::StatusTypes::PENDING_INTRO)
    end

    it "creates an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::ApplicantStatusUpdated::V6,
        application_id: applicant.id,
        data: {
          applicant_first_name: applicant.seeker.user.first_name,
          applicant_last_name: applicant.seeker.user.last_name,
          applicant_email: applicant.seeker.user.email,
          applicant_phone_number: applicant.seeker.user.phone_number,
          seeker_id: applicant.seeker.id,
          job_id: applicant.job.id,
          employer_name: applicant.job.employer.name,
          user_id: applicant.seeker.user.id,
          employment_title: applicant.job.employment_title,
          status: ApplicantStatus::StatusTypes::PENDING_INTRO,
          reasons: [
            Events::ApplicantStatusUpdated::Reason::V2.new(
              id: reason.id,
              response: "Bad canidate",
              reason_description: "This is a description"
            )
          ]
        },
        metadata: {
          user_id:
        },
        occurred_at: anything
      ).and_call_original

      subject
    end
  end
end
