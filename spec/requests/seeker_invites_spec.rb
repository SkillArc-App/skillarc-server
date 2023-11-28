require 'rails_helper'

RSpec.describe "SeekerInvites", type: :request do
  describe "GET /index" do
    subject { get seeker_invites_path, headers: headers }

    it_behaves_like "admin authenticated"
  end

  describe "POST /create" do
    subject { post seeker_invites_path, params: params, headers: headers }

    include_context "admin authenticated"

    let!(:program) { create(:program, training_provider:) }
    let!(:training_provider) { create(:training_provider) }

    let(:params) do
      {
        seeker_invite: {
          email: "hannah@blocktrainapp.com",
          first_name: "Hannah",
          last_name: "Block",
          program_id: program.id,
          training_provider_id: training_provider.id
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a seeker invite" do
      expect { subject }.to change { SeekerInvite.count }.by(1)
    end
  end
end
