require 'rails_helper'

RSpec.describe "OnboardingSessions", type: :request do
  describe "GET /index" do
    subject { get onboarding_sessions_path }

    it_behaves_like "admin secured endpoint"
  end

  describe "PUT /update" do
    subject { put onboarding_session_path(onboarding_session), params: params }

    include_context "authenticated"

    let(:onboarding_session) { create(:onboarding_session, user:) }
    let(:params) do
      {
        onboarding_session: {
          responses: {
            name: {
              response: {
                firstName: "Hannah",
                lastName: "Montana",
                phoneNumber: "1234567890",
                dateOfBirth: "01/01/2000"
              }
            },
          }
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end
  end
end
