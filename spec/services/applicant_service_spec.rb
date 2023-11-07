require 'rails_helper'

RSpec.describe ApplicantService do
  subject { described_class.new(applicant) }

  let(:applicant) { create(:applicant) }

  describe "#update_status" do
    it "creates a new applicant status" do
      expect do
        subject.update_status(ApplicantStatus::StatusTypes::PENDING_INTRO)
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

      subject.update_status(ApplicantStatus::StatusTypes::PENDING_INTRO)
    end
  end
end