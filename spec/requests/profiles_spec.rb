require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  describe "GET /index" do
    subject { get profiles_path }

    it_behaves_like "admin secured endpoint"
  end

  describe "GET /show" do
    subject { get profile_path(profile) }

    let(:profile) { create(:profile) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end
  end
end
