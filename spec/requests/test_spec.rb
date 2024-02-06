require 'rails_helper'

RSpec.describe "Test", type: :request do
  describe "POST /create_test_user" do
    subject { post create_user_test_path, params:, headers: }

    let(:headers) { {} }
    let(:params) { {} }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create_coach" do
    subject { post create_coach_test_path, params:, headers: }

    let(:headers) { {} }
    let(:params) { {} }

    before do
      create(:role, name: Role::Types::COACH)
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create_seeker" do
    subject { post create_seeker_test_path, params:, headers: }

    let(:headers) { {} }
    let(:params) { {} }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create_job" do
    subject { post create_job_test_path, params:, headers: }

    let(:headers) { {} }
    let(:params) { {} }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create_test_recruiter_with_applicant" do
    subject { post create_recruiter_with_applicant_test_path, params:, headers: }

    let(:headers) { {} }
    let(:params) { {} }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create_seeker_lead" do
    subject { post create_seeker_lead_test_path, params:, headers: }

    let(:headers) { {} }
    let(:params) { {} }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create_active_seeker" do
    subject { post create_active_seeker_test_path, params:, headers: }

    let(:headers) { {} }
    let(:params) { {} }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /reset_database" do
    # Not tested as it is sort of weird reseting the db in a test
  end
end
