require "rails_helper"

RSpec.describe JobMatch::JobMatch do
  subject { described_class.new(user:) }

  let(:user) { create(:user) }
  let!(:seeker) { create(:seeker, user:) }

  let(:saved_job) { create(:job) }
  let!(:unsaved_job) { create(:job) }
  let(:applied_job) { create(:job) }

  before do
    create(:event, :job_saved, aggregate_id: user.id, data: { job_id: saved_job.id })
    create(:event, :job_unsaved, aggregate_id: user.id, data: { job_id: saved_job.id })
    create(:event, :job_saved, aggregate_id: user.id, data: { job_id: saved_job.id })

    create(:applicant, seeker:, job: applied_job)
  end

  it "initializes with a list of jobs" do
    expect(subject.jobs).not_to be_nil
  end

  it "returns a list of jobs with a percent match" do
    expect(subject.jobs.first[:percent_match]).to eq(1)
  end

  it "returns a correct saved status" do
    expect(subject.jobs).to include(hash_including(id: saved_job.id, saved: true))
    expect(subject.jobs).to include(hash_including(id: unsaved_job.id, saved: false))
  end

  context "new application" do
    it "returns a correct applied status" do
      expect(subject.jobs).to include(hash_including(id: saved_job.id, applied: false))
      expect(subject.jobs).to include(hash_including(id: applied_job.id, applied: true, applicationStatus: "Application Sent"))
    end
  end

  context "pending intro application" do
    before do
      create(:applicant_status, :pending_intro, applicant: applied_job.applicants.first)
    end

    it "returns a correct applied status" do
      expect(subject.jobs).to include(hash_including(id: applied_job.id, applied: true, applicationStatus: "Introduction Sent"))
    end
  end

  context "interviewing application" do
    before do
      create(:applicant_status, :interviewing, applicant: applied_job.applicants.first)
    end

    it "returns a correct applied status" do
      expect(subject.jobs).to include(hash_including(id: applied_job.id, applied: true, applicationStatus: "Interview in Progress"))
    end
  end
end
