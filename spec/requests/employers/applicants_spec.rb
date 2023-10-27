require 'rails_helper'

RSpec.describe "Employers::Applicants", type: :request do
  describe "PUT /update" do
    subject { put employers_applicant_path(applicant), params: params }

    include_context "employer authenticated"

    let(:applicant) { create(:applicant) }
    let(:params) do
      {
        status: ApplicantStatus::StatusTypes::PENDING_INTRO
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "updates the applicant status" do
      expect { subject }.to change { applicant.reload.status.status }.to(ApplicantStatus::StatusTypes::PENDING_INTRO)
    end
  end
end
