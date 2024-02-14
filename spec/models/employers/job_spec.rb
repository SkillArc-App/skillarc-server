require 'rails_helper'

RSpec.describe Employers::Job, type: :model do
  describe "#owner_email" do
    subject { job.owner_email }

    let(:job) { create(:employers_job) }
    let!(:recruiter) { create(:employers_recruiter, employer: job.employer) }

    it "returns the first recruiter's email" do
      expect(subject).to eq(recruiter.email)
    end
  end
end
