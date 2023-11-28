require 'rails_helper'

RSpec.describe "DesiredCertifications", type: :request do
  describe "CREATE /create" do
    subject { post job_desired_certifications_path(job), params: params, headers: headers }

    include_context "admin authenticated"

    let(:job) { create(:job) }
    let(:params) do
      {
        master_certification_id: master_certification.id
      }
    end
    let(:master_certification) { create(:master_certification) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a desired certification" do
      expect { subject }.to change { DesiredCertification.count }.by(1)
    end
  end

  describe "DELETE /destroy" do
    subject { delete job_desired_certification_path(job, desired_certification), headers: headers }

    include_context "admin authenticated"

    let(:job) { create(:job) }
    let!(:desired_certification) { create(:desired_certification, job: job) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "deletes the desired certification" do
      expect { subject }.to change { DesiredCertification.count }.by(-1)
    end
  end
end
