require 'rails_helper'

RSpec.describe "EmployerInvites", type: :request do
  describe "GET /index" do
    subject { get employer_invites_path }

    it_behaves_like "admin secured endpoint"
  end

  describe "POST /create" do
    subject { post employer_invites_path, params: params }

    include_context "admin authenticated"

    let(:params) do
      {
        employer_invite: {
          email: Faker::Internet.email,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          employer_id: employer.id
        }
      }
    end
    let(:employer) { create(:employer) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates an employer invite" do
      expect { subject }.to change { EmployerInvite.count }.by(1)
    end
  end
end
