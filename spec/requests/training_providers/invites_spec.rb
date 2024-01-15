require 'rails_helper'

RSpec.describe "TrainingProviders::Invites", type: :request do
  describe "POST /create" do
    subject { post training_providers_invites_path, params:, headers: }

    include_context "training provider authenticated"

    let(:params) do
      {
        invitees: [{
          email: "hannah@blocktrainapp.com",
          first_name: "Hannah",
          last_name: "Block",
          program_id: program.id
        }]
      }
    end
    let(:program) { create(:program, training_provider: build(:training_provider)) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates an invite" do
      expect { subject }.to change(SeekerInvite, :count).by(1)
    end
  end
end
