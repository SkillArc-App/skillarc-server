require 'rails_helper'

RSpec.describe Jobs::DesiredCertificationService do
  describe ".create" do
    subject { described_class.create(job, master_certification_id) }

    include_context "event emitter"

    let(:job) { create(:job) }
    let(:master_certification_id) { create(:master_certification).id }

    it "publishes an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::DesiredCertificationCreated::V1,
        job_id: job.id,
        data: {
          id: be_present,
          job_id: job.id,
          master_certification_id:
        }
      ).and_call_original

      subject
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(desired_certification) }

    include_context "event emitter"

    let!(:desired_certification) { create(:desired_certification) }

    it "publishes an event" do
      expect_any_instance_of(MessageService).to receive(:create!).with(
        schema: Events::DesiredCertificationDestroyed::V1,
        job_id: desired_certification.job_id,
        data: {
          id: desired_certification.id
        }
      )

      subject
    end
  end
end
