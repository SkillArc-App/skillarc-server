require 'rails_helper'

RSpec.describe "OneUsers", type: :request do
  describe "GET /index" do
    subject { get one_user_path, headers: }

    it_behaves_like "admin secured endpoint"
  end

  describe "PUT /update" do
    subject { put one_user_path(user), params:, headers: }

    include_context "authenticated"

    let(:params) do
      {
        one_user: {
          first_name: "Hannah"
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the user" do
      subject

      expect(user.reload.first_name).to eq("Hannah")
    end
  end
end
