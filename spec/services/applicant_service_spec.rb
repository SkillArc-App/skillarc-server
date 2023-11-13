require 'rails_helper'

RSpec.describe ApplicantService do
  let(:applicant) { create(:applicant) }

  describe "#update_status" do
    subject { described_class.new(applicant).update_status(status: status, reasons: reasons) }

    let(:status) { ApplicantStatus::StatusTypes::PENDING_INTRO }
    let(:reasons) { [reason.id] }
    let(:reason) { create(:reason) }

    it "creates a new applicant status" do
      expect do
        subject
      end.to change { applicant.reload.applicant_statuses.count }.by(1)

      expect(applicant.status.status).to eq(ApplicantStatus::StatusTypes::PENDING_INTRO)
    end

    it "creates an event" do
      expect(Resque).to receive(:enqueue).with(
        CreateEventJob,
        event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
        aggregate_id: applicant.job.id,
        data: {
          applicant_id: applicant.id,
          profile_id: applicant.profile.id,
          user_id: applicant.profile.user.id,
          employment_title: applicant.job.employment_title,
          status: ApplicantStatus::StatusTypes::PENDING_INTRO
        },
        metadata: {},
        occurred_at: anything
      )

      subject
    end

    it "attaches applicant status reasons" do
      expect do
        subject
      end.to change { applicant.reload.applicant_statuses.last.applicant_status_reasons.count }.by(1)

      expect(applicant.applicant_statuses.last.applicant_status_reasons.last.reason).to eq(reason)
    end
  end
end