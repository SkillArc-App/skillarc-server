require 'rails_helper'

RSpec.describe Jobs::DesiredCertificationService do
  describe ".create" do
    subject { described_class.create(job, master_certification_id) }

    let(:job) { create(:job) }
    let(:master_certification_id) { create(:master_certification).id }

    it "creates a desired certification" do
      expect { subject }.to change { job.desired_certifications.count }.by(1)
    end

    it "publishes an event" do
      expect(Events::DesiredCertificationCreated::Data::V1).to receive(:new).with(
        id: be_present,
        job_id: job.id,
        master_certification_id:
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::DesiredCertificationCreated::V1,
        job_id: job.id,
        data: be_a(Events::DesiredCertificationCreated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(desired_certification) }

    let!(:desired_certification) { create(:desired_certification) }

    it "destroys the desired certification" do
      expect { subject }.to change { DesiredCertification.count }.by(-1)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::DesiredCertificationDestroyed::V1,
        job_id: desired_certification.job_id,
        data: Events::DesiredCertificationDestroyed::Data::V1.new(
          id: desired_certification.id
        )
      )

      subject
    end
  end
end
