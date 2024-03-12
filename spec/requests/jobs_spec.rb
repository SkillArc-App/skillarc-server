require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  describe "GET /show" do
    subject { get job_path(job), headers: }

    let(:job) { create(:job) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /apply" do
    subject { post job_apply_path(job), headers: }

    before do
      allow_any_instance_of(Employers::EmployerService).to receive(:handle_message)
    end

    include_context "authenticated"

    let(:job) { create(:job) }
    let!(:search__job) { create(:search__job, job_id: job.id) }
    let!(:seeker) { create(:seeker, user:) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates an applicant" do
      expect { subject }.to change(Applicant, :count).by(1)
    end
  end

  describe "POST /elevator_pitch" do
    subject { post job_elevator_pitch_path(job), params:, headers: }

    let(:job) { create(:job) }
    let(:params) { { elevator_pitch: "New Elevator Pitch" } }
    let!(:seeker) { create(:seeker) }
    let!(:applicant) { create(:applicant, job:, seeker:) }
    let(:user) { nil }

    before do
      seeker.update(user:) if user
    end

    it_behaves_like "a secured endpoint"

    context "authenticated" do
      include_context "authenticated"

      it "calls the Seekers::JobService" do
        expect(Seekers::JobService)
          .to receive(:new)
          .with(job:, seeker:)
          .and_call_original

        expect_any_instance_of(Seekers::JobService)
          .to receive(:add_elevator_pitch)
          .with("New Elevator Pitch")
          .and_call_original

        subject
      end
    end
  end
end
