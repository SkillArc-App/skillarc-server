require 'rails_helper'

RSpec.describe "SeekerTrainingProviders", type: :request do
  include_context "admin authenticated"

  let!(:training_provider) { create(:training_provider) }
  let!(:program) { create(:program, training_provider:) }

  let(:profile) { create(:profile, user: build(:user)) }

  describe "POST /create" do
    subject { post seeker_training_providers_path(seeker_id: profile.id), params:, headers: }

    let(:params) do
      {
        programId: program.id,
        trainingProviderId: training_provider.id
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates a seeker training provider" do
      expect { subject }.to change(SeekerTrainingProvider, :count).by(1)
    end
  end

  describe "PUT /update" do
    subject { put seeker_training_provider_path(seeker_id: profile.id, id: stp.id), params:, headers: }

    let(:stp) { create(:seeker_training_provider, user: profile.user, training_provider:, program:) }
    let!(:new_training_provider) { create(:training_provider) }
    let!(:new_program) { create(:program, training_provider:) }

    let(:params) do
      {
        programId: new_program.id,
        trainingProviderId: new_training_provider.id
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the seeker training provider" do
      subject

      expect(stp.reload.program_id).to eq(new_program.id)
      expect(stp.reload.training_provider_id).to eq(new_training_provider.id)
    end
  end
end
