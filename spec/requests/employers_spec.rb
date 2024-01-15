require 'rails_helper'

RSpec.describe "Employers", type: :request do
  describe "GET /index" do
    subject { get employers_path, headers: }

    it_behaves_like "admin secured endpoint"
  end

  describe "GET /show" do
    subject { get employer_path(employer), headers: }

    let(:employer) { create(:employer) }

    it_behaves_like "admin secured endpoint"
  end

  describe "POST /create" do
    subject { post employers_path, params:, headers: }

    include_context "admin authenticated"

    let(:params) do
      {
        employer: {
          name: "Blocktrain",
          bio: "We are a company",
          logo_url: "https://www.blocktrain.com/logo.png",
          location: "Columbus, OH"
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates an employer" do
      expect { subject }.to change(Employer, :count).by(1)
    end
  end

  describe "PUT /update" do
    subject { put employer_path(employer), params:, headers: }

    include_context "admin authenticated"

    let(:employer) { create(:employer) }
    let(:params) do
      {
        employer: {
          name: "Blocktrain 2.0"
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the employer" do
      expect { subject }.to change { employer.reload.name }.to("Blocktrain 2.0")
    end
  end
end
