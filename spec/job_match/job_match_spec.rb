require "rails_helper"

RSpec.describe JobMatch::JobMatch do
  subject { described_class.new(user:) }

  let(:user) { create(:user) }
  let!(:seeker) { create(:seeker, user:) }

  let(:saved_job) { create(:job) }
  let!(:unsaved_job) { create(:job) }
  let(:applied_job) { create(:job) }

  before do
    create(:event, :job_saved, aggregate_id: user.id, data: { job_id: saved_job.id, employment_title: "A", employer_name: "B" })
    create(:event, :job_unsaved, aggregate_id: user.id, data: { job_id: saved_job.id, employment_title: "A", employer_name: "B" })
    create(:event, :job_saved, aggregate_id: user.id, data: { job_id: saved_job.id, employment_title: "A", employer_name: "B" })
  end
  let!(:applicant) { create(:applicant, seeker:, job_id: applied_job.id, elevator_pitch: "pitch") }

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

  it "returns an elevator pitch" do
    expect(subject.jobs).to include(hash_including(id: applied_job.id, elevator_pitch: "pitch"))
  end

  context "new application" do
    it "returns a correct applied status" do
      expect(subject.jobs).to include(hash_including(id: saved_job.id, applied: false))
      expect(subject.jobs).to include(hash_including(id: applied_job.id, applied: true, application_status: "Application Sent"))
    end
  end

  context "pending intro application" do
    before do
      create(:applicant_status, :pending_intro, applicant:)
    end

    it "returns a correct applied status" do
      expect(subject.jobs).to include(
        hash_including(
          id: applied_job.id,
          applied: true,
          application_status: "Introduction Sent"
        )
      )
    end
  end

  context "interviewing application" do
    before do
      create(:applicant_status, :interviewing, applicant:)
    end

    it "returns a correct applied status" do
      expect(subject.jobs).to include(
        hash_including(
          id: applied_job.id,
          applied: true,
          application_status: "Interview in Progress"
        )
      )
    end
  end
end
