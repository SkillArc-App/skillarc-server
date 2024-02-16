require 'rails_helper'

RSpec.describe "Employers::Applicants", type: :request do
  describe "PUT /update" do
    subject { put employers_applicant_path(applicant), params:, headers: }

    include_context "employer authenticated"

    let(:applicant) { create(:applicant) }
    let(:params) do
      {
        status: ApplicantStatus::StatusTypes::PENDING_INTRO,
        reasons: [reason.id]
      }
    end
    let(:reason) { create(:reason) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "calls ApplicantService" do
      expect_any_instance_of(ApplicantService)
        .to receive(:update_status)
        .with(status: ApplicantStatus::StatusTypes::PENDING_INTRO, reasons: [{ id: reason.id, response: nil }])

      subject
    end

    context "when there are no reasons" do
      let(:params) do
        {
          status: ApplicantStatus::StatusTypes::PENDING_INTRO
        }
      end

      it "calls ApplicantService" do
        expect_any_instance_of(ApplicantService)
          .to receive(:update_status)
          .with(status: ApplicantStatus::StatusTypes::PENDING_INTRO, reasons: [])
          .and_call_original

        subject
      end
    end
  end
end
