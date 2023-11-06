require 'rails_helper'

RSpec.describe User do
  subject { create(:user) }

  describe "#applied_jobs" do
    context "when there are not applicants" do
      it "returns an empty array" do
        expect(subject.applied_jobs).to eq([])
      end
    end

    context "when there is an applicant" do
      let(:job) { create(:job) }
      let!(:applicant) { create(:applicant, job:, profile:) }
      let(:profile) { create(:profile, user: subject) }

      it "returns an array with the job" do
        expect(subject.applied_jobs).to eq([job])
      end
    end
  end

  describe "#saved_jobs" do
    context "when there are not job saved events" do
      it "returns an empty array" do
        expect(subject.saved_jobs).to eq([])
      end
    end

    context "when there is a job saved event" do
      let!(:event) { create(:event, :job_saved, aggregate_id: subject.id, data: { job_id: job.id }) }
      let(:job) { create(:job) }

      it "returns an array with the job" do
        expect(subject.saved_jobs).to eq([job])
      end

      context "when there is a job unsaved event after the job saved event" do
        let!(:unsaved_event) do
          create(
            :event,
            :job_unsaved,
            aggregate_id: subject.id,
            data: { job_id: job.id },
            occurred_at: event.occurred_at + 1.second
          )
        end

        it "returns an empty array" do
          expect(subject.saved_jobs).to eq([])
        end
      end
    end
  end
end