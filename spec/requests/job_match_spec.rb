require 'rails_helper'

RSpec.describe "JobMatch", type: :request do
  let(:job) { create(:job) }

  describe "GET /index" do
    subject { get job_matches_path, headers: }

    it_behaves_like "a secured endpoint"

    context "authorized" do
      include_context "authenticated"

      let(:job_match) { JobMatch::JobMatch.new(user:) }

      it "calls Jobs::JobPhotosService.create" do
        expect(JobMatch::JobMatch).to receive(:new).with(user:).and_return(job_match)
        expect(job_match).to receive(:jobs).and_call_original

        subject

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
