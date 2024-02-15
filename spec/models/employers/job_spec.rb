require 'rails_helper'

RSpec.describe Employers::Job, type: :model do
  describe "#owner_email" do
    subject { job.owner_email }

    let(:job) { create(:employers_job) }
    let!(:recruiter) { create(:employers_recruiter, employer: job.employer) }

    context "when there is no job owner" do
      it "returns the first recruiter's email" do
        expect(subject).to eq(recruiter.email)
      end
    end

    context "when there is a job owner" do
      let!(:job_owner) { create(:employers_job_owner, job:, recruiter: other_recruiter) }
      let(:other_recruiter) { create(:employers_recruiter, employer: job.employer) }

      it "returns the job owner's email" do
        expect(subject).to eq(other_recruiter.email)
      end
    end
  end
end
